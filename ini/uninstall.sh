#!/bin/bash

set -e
PROJECT_ROOT=$(pwd)
CURRENT_DIR=$(basename "$(pwd)" | tr -d '[:space:]')

# Force execute from the root directory to avoid files created in the wrong directory
if [[ "$CURRENT_DIR" == "ini" ]]; then
    echo "Changed directory to root."
    cd ..
fi

# Uninstall GCC installed via Homebrew
if brew list gcc &>/dev/null; then
    brew uninstall gcc
    echo "Uninstalled GCC."
else
    echo "GCC not installed via Homebrew. Skipping."
fi

# Remove bits/stdc++.h file from user-specific directory
TARGET_INCLUDE_DIR="$HOME/.local/include/bits"
if [ -f "$TARGET_INCLUDE_DIR/stdc++.h" ]; then
    rm "$TARGET_INCLUDE_DIR/stdc++.h"
    echo "Removed bits/stdc++.h."
else
    echo "bits/stdc++.h not found in $TARGET_INCLUDE_DIR. Skipping."
fi

# Uninstall CMake installed via Homebrew
if brew list cmake &>/dev/null; then
    brew uninstall cmake
    echo "Uninstalled CMake."
else
    echo "CMake not installed via Homebrew. Skipping."
fi

# Uninstall GDB installed via Homebrew (for x86_64 architecture)
if [ "$(uname -m)" == "x86_64" ]; then
    if brew list gdb &>/dev/null; then
        brew uninstall gdb
        echo "Uninstalled GDB."
    else
        echo "GDB not installed via Homebrew. Skipping."
    fi
else
    echo "GDB is not available on ARM64 architecture. Skipping."
fi

# Remove Visual Studio Code extensions
code --uninstall-extension ms-vscode.cpptools
code --uninstall-extension ms-vscode.cmake-tools
code --uninstall-extension vadimcn.vscode-lldb
echo "Uninstalled VSCode C++ extensions."

echo "C++ environment reset complete. Please restart your terminal for changes to take effect."
