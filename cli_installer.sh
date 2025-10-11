#!/bin/bash

REPOSITORY_BRANCH="main"
if [ "$#" -eq 1 ]; then
  echo "Found version $1"
  REPOSITORY_BRANCH="$1"
fi

# Config
REPOSITORY="git@git.moon-dev.com:alphalogy/alphalogy-cli-releases.git"
LOCAL_DIR="$HOME/.alp"

echo "ℹ️ Install Alp Cli"
#Make .alp dir and clone release
mkdir "$LOCAL_DIR"
cd "$LOCAL_DIR" || exit 1

# Clone repo shallowly, no checkout
git clone -b "$REPOSITORY_BRANCH" "$REPOSITORY" .

chmod +x "./alp"
# Ensure ~/.alp is in PATH via .zshrc
if ! grep -q "export PATH=\"$HOME/.alp:\$PATH\"" "$HOME/.zshrc"; then
    echo "export PATH=\"$HOME/.alp:\$PATH\"" >> "$HOME/.zshrc"
    echo "✅ Added ~/.alp to PATH in .zshrc"
else
    echo "ℹ️ ~/.alp already in PATH"
fi

echo "🚀 CLI 'alp' is installed/updated and ready to use!"