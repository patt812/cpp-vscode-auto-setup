#!/bin/bash

set -e
PROJECT_ROOT=$(pwd)
CURRENT_DIR=$(basename "$(pwd)" | tr -d '[:space:]')

# Force execute from the root directory to avoid files created in the wrong directory
if [[ "$CURRENT_DIR" == "ini" ]]; then
    cd ..
    echo "Changed directory to root."
fi

# Check if VSCode's `code` command is available
if ! command -v code &> /dev/null; then
    echo "VSCode's 'code' command is not available. Please install VSCode and ensure 'code' is in your PATH."
    exit 1
fi

# Install specific version of GCC (12.2) if not already installed
if ! brew list gcc@12 &>/dev/null; then
    brew install gcc@12
else
    echo "gcc@12 is already installed. Skipped."
fi

# Set the correct GCC path (version 12.2)
GCC_PATH=$(brew --prefix gcc@12)
GPP_PATH="$GCC_PATH/bin/g++-12"

# Check if bits/stdc++.h exists, if not, download it
TARGET_INCLUDE_DIR="$HOME/.local/include/bits"
mkdir -p "$TARGET_INCLUDE_DIR"
if [ ! -f "$TARGET_INCLUDE_DIR/stdc++.h" ];then
    echo "bits/stdc++.h not found. Downloading and setting it up..."
    curl -o "$TARGET_INCLUDE_DIR/stdc++.h" https://gist.githubusercontent.com/mohd-akram/3f6b7efb72b5e0dc2e31/raw/0d4b5a66b65a019b1e6b0d16225b1b5a9e1c2c7c/stdc++.h
    echo "bits/stdc++.h has been downloaded and placed in $TARGET_INCLUDE_DIR."
else
    echo "bits/stdc++.h already exists. Skipped."
fi

# Install CMake if not already installed
if ! brew list cmake &>/dev/null; then
    brew install cmake
else
    echo "cmake is already installed. Skipped."
fi

# Check for arm64 architecture and suggest using LLDB instead of GDB
if [[ $(uname -m) == "arm64" ]]; then
    echo "GDB is not available on Mac arm64 architecture. Using LLDB instead."
else
    # Install GDB for x86_64 architecture if not already installed
    if ! brew list gdb &>/dev/null; then
        brew install gdb
    else
        echo "gdb is already installed. Skipped."
    fi
fi

# Install VSCode extensions for C++ and debugging
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools
code --install-extension vadimcn.vscode-lldb

# Create .vscode directory and settings files
mkdir -p .vscode

# Create settings.json
cat <<EOL > .vscode/settings.json
{
    "C_Cpp.default.compilerPath": "$GPP_PATH",
    "cmake.configureOnOpen": true
}
EOL

# Create tasks.json
cat <<EOL > .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build with gcc",
            "type": "shell",
            "command": "$GPP_PATH", 
            "args": [
                "-std=c++20",
                "-gdwarf-3",
                "\${file}",
                "-o",
                "bin/a.out",
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
EOL

# Create launch.json
cat <<EOL > .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "C++ Debug",
            "type": "lldb",
            "request": "launch",
            "program": "\${workspaceFolder}/bin/a.out",
            "args": [],
            "cwd": "\${workspaceFolder}",
            "preLaunchTask": "Build with gcc"
        }
    ]
}
EOL

# Create c_cpp_properties.json
cat <<EOL > .vscode/c_cpp_properties.json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "\${workspaceFolder}/**",
                "$GCC_PATH/include/c++/12",
                "/usr/local/include"
            ],
            "defines": [],
            "macFrameworkPath": [
                "/System/Library/Frameworks",
                "/Library/Frameworks"
            ],
            "compilerPath": "$GPP_PATH",
            "cppStandard": "c++20",
            "intelliSenseMode": "gcc-x64"
        }
    ],
    "version": 4
}
EOL

# Create bin directory for compiled binaries
mkdir -p bin

# Create test directory structure and files
mkdir -p test/utils

# Create test/input.cpp
cat <<EOL > test/input.cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    int n;
    cin >> n;
    cout << n << endl;
    return 0;
}
EOL

# Create test/text.cpp
cat <<EOL > test/text.cpp
#include <bits/stdc++.h>
#include "utils/file.cpp"
using namespace std;

int calculateSum(vector<int>& arr) {
    int sum = 0;
    for (int num : arr) {
        sum += num;
    }
    return sum;
}

double calculateAverage(vector<int>& arr) {
    if (arr.empty()) return 0.0;
    return static_cast<double>(calculateSum(arr)) / arr.size();
}

int findMaxValue(vector<int>& arr) {
    return *max_element(arr.begin(), arr.end());
}

int main() {
    vector<vector<int>> testCases = readInputFile();

    for (const auto& arr : testCases) {
        int sum = calculateSum(const_cast<vector<int>&>(arr));
        double average = calculateAverage(const_cast<vector<int>&>(arr));
        int maxValue = findMaxValue(const_cast<vector<int>&>(arr));

        cout << "Sum: " << sum << endl;
        cout << "Average: " << average << endl;
        cout << "Max Value: " << maxValue << endl;
        cout << "------" << endl;
    }

    return 0;
}
EOL

# Create test/utils/input.txt
cat <<EOL > test/utils/input.txt
5
3 1 4 1 5
7
10 9 8 7 6 5 4
3
15 20 30
EOL

# Create test/utils/file.cpp
cat <<EOL > test/utils/file.cpp
#include <fstream>
#include <iostream>
#include <vector>
#include <string>

std::vector<std::vector<int>> readInputFile() {
    std::string filename = "test/utils/input.txt";
    std::ifstream inputFile(filename);
    if (!inputFile) {
        std::cerr << "Error: Could not open input file: " << filename << std::endl;
        exit(1);
    }

    int testCaseCount;
    inputFile >> testCaseCount;

    std::vector<std::vector<int>> testCases;
    while (testCaseCount--) {
        int n;
        inputFile >> n;
        std::vector<int> arr(n);
        for (int i = 0; i < n; ++i) {
            inputFile >> arr[i];
        }
        testCases.push_back(arr);
    }

    inputFile.close();
    return testCases;
}
EOL

echo "Install complete."
