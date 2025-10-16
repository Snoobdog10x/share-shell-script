#!/bin/bash
REPOSITORY_BRANCH="main"
if [ "$#" -eq 1 ]; then
  echo "Found version $1"
  REPOSITORY_BRANCH="$1"
fi

# Config
REPOSITORY="git@git.moon-dev.com:alphalogy/alphalogy-cli-releases.git"
LOCAL_DIR="$HOME/.alp"
ALP_PATH="$LOCAL_DIR/alp"

echo "ℹ️ Install Alp CLI"

# --- Step 1: Deactivate old alp via dart ---
dart pub global deactivate alphalogy_cli || echo "ℹ️ No global package found or already deactivated."

# --- Step 2: Install or Update Alp ---
echo "⬇️ Installing/Updating alp from branch '$REPOSITORY_BRANCH'..."

rm -rf "$LOCAL_DIR"
mkdir -p "$LOCAL_DIR"
cd "$LOCAL_DIR" || exit 1

git clone -b "$REPOSITORY_BRANCH" "$REPOSITORY" --depth 1 .
rm -rf .git

chmod +x "$ALP_PATH"

# --- Step 3: Ensure ~/.alp in PATH ---
if ! grep -q "export PATH=\"$HOME/.alp:\$PATH\"" "$HOME/.zshrc"; then
  echo "export PATH=\"$HOME/.alp:\$PATH\"" >> "$HOME/.zshrc"
  echo "✅ Added ~/.alp to PATH in .zshrc"
else
  echo "ℹ️ ~/.alp already in PATH"
fi

echo "🚀 CLI 'alp' is installed/updated and ready to use!"
