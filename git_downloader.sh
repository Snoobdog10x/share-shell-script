#!/bin/bash

# Usage:
# ./download-single-file.sh <repository> <branch> <remote_path> <local_path>
# Check input arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <repository_ssh_url> <branch> <remote_file_path> <local_output_path>"
  exit 1
fi

# Read arguments
REPOSITORY="$1"
REPOSITORY_BRANCH="$2"
REMOTE_PATH="$3"
LOCAL_PATH="$4"

# Save current directory
CURRENT_DIR="$(pwd)"

# Create temporary directory
TMP_DIR=$(mktemp -d -t singlefile-XXXXXXXXXX)
cd "$TMP_DIR" || exit 1

# Clone repo shallowly, no checkout
git clone -b "$REPOSITORY_BRANCH" -n "$REPOSITORY" --depth 1 .

# Checkout only the specific file
git checkout HEAD -- "$REMOTE_PATH"

# Move the file to the destination
if [[ "$LOCAL_PATH" = /* ]]; then
    # Absolute path
    mkdir -p "$(dirname "$LOCAL_PATH")"
    mv "$REMOTE_PATH" "$LOCAL_PATH"
else
    # Relative path
    mkdir -p "$(dirname "$CURRENT_DIR/$LOCAL_PATH")"
    mv "$REMOTE_PATH" "$CURRENT_DIR/$LOCAL_PATH"
fi

# Cleanup
cd "$CURRENT_DIR" && rm -rf "$TMP_DIR"

echo "✅ File '$REMOTE_PATH' has been saved to '$LOCAL_PATH'"