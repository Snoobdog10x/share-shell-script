#!/bin/bash

REPOSITORY_BRANCH="main"
if [ "$#" -eq 1 ]; then
  echo "Found version $1"
  REPOSITORY_BRANCH="$1"
fi

# Config
REPOSITORY="git@git.moon-dev.com:alphalogy-app/alphalogy-cli.git"
REMOTE_PATH="executable/alp"
LOCAL_PATH="$HOME/.alp/alp"

# Save current directory
CURRENT_DIR="$(pwd)"

# Create temporary directory
TMP_DIR=$(mktemp -d -t singlefile-XXXXXXXXXX)
cd "$TMP_DIR" || exit 1

# Clone repo shallowly, no checkout
git clone -b "$REPOSITORY_BRANCH" -n "$REPOSITORY" --depth 1 .

# Checkout only the specific file
git checkout HEAD -- "$REMOTE_PATH"

if [[ ! -e "$REMOTE_PATH" ]]; then
  echo "❌ Source file not found: $REMOTE_PATH, please check the version"
  # cleanup if needed
  cd "$CURRENT_DIR" && rm -rf "$TMP_DIR"
  exit 1
fi

# Move the file to the destination
mkdir -p "$(dirname "$LOCAL_PATH")"
mv "$REMOTE_PATH" "$LOCAL_PATH"

# Cleanup
cd "$CURRENT_DIR" && rm -rf "$TMP_DIR"

# Make executable
chmod +x "$LOCAL_PATH"
echo "✅ File '$REMOTE_PATH' has been saved to '$LOCAL_PATH' and made executable."

# Ensure ~/.alp is in PATH via .zshrc
if ! grep -q "export PATH=\"$HOME/.alp:\$PATH\"" "$HOME/.zshrc"; then
    echo "export PATH=\"$HOME/.alp:\$PATH\"" >> "$HOME/.zshrc"
    echo "✅ Added ~/.alp to PATH in .zshrc"
else
    echo "ℹ️ ~/.alp already in PATH"
fi

echo "🚀 CLI 'alp' is installed/updated and ready to use!"