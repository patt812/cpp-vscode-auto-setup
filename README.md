# C++ VSCode Auto Setup

**MacOS ONLY.**

This project provides a script that automatically sets up a C++ environment tailored for competitive programming. 

It installs the necessary tools and configures Visual Studio Code. With just pressing F5, you can build and debug your project.

## Features
- Installs necessary development tools: GCC, CMake, GDB (or LLDB on macOS ARM64).
- Automatically installs recommended Visual Studio Code extensions for C++ development:
    - ms-vscode.cpptools
    - ms-vscode.cmake-tools
    - vadimcn.vscode-lldb
- No `sudo` required.
- Provides a C++ test program for competitive programming.

## Prerequisites
macOS with Homebrew installed.

**Note**: This script has only been tested on Apple Silicon(M3).

## Version
- C++: C++20
- GCC: 12.4.x
- CMake: Latest version
- Debugger: GDB (x86_64) or LLDB (ARM64)

## Installation

1. Go to the GitHub repository page and click the `Use this template` button to create a new repository.

2. Clone the newly created repository to your local machine.

```bash
git clone https://github.com/your-repo/cpp-vscode-auto-setup.git
cd cpp-vscode-auto-setup
```

3. Make the script executable.

```bash
chmod +x ini/*.sh
```

4. Run the setup script to install dependencies and configure your environment.

```bash
ini/install.sh
```

## Uninstallation
To reset the environment, run the following script:

```bash
ini/uninstall.sh
```

**Note**: This script will only uninstall the dependencies and Visual Studio Code extensions installed via Homebrew. It will not delete any project files.

## Usage
1. Open Visual Studio Code in the project directory.

2. Press `F5` to automatically build and debug the project. The generated binary will be placed in the `bin` directory.

## Example Project
The script creates the following test files:

### `test/input.cpp`
    ```cpp
    #include <bits/stdc++.h>
    using namespace std;

    int main() {
        int n;
        cin >> n;
        cout << n << endl;
        return 0;
    }
    ```
    This file is a simple input/output example.

### `test/text.cpp`
    ```cpp
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
    ```
    This file reads test cases from `test/utils/input.txt`, calculates the sum, average, and maximum value for each case.

#### `test/utils/input.txt`  
   ```txt
   5
   3 1 4 1 5
   7
   10 9 8 7 6 5 4
   3
   15 20 30
   ```

## Troubleshooting
- Ensure you have Homebrew installed on your system.
  - `brew update` might help if you encounter any issues.
- If GCC or CMake is already installed, the script will skip their installation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
