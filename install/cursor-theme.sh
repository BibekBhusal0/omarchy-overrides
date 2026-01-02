#!/bin/bash

THEME_NAME="ArcDusk-cursors"
REPO_URL="https://github.com/yeyushengfan258/ArcDusk-Cursors"
ICONS_DIR="$HOME/.local/share/icons"
TEMP_DIR="/tmp/cursor-install"

# Check if theme already exists
if [ -d "$ICONS_DIR/$THEME_NAME" ]; then
    echo "Theme already installed at $ICONS_DIR/$THEME_NAME"
    echo "Testing theme..."
    hyprctl setcursor "$THEME_NAME" 24
    if [ $? -eq 0 ]; then
        echo "Theme works! "
    fi
    exit 0
fi

mkdir -p "$ICONS_DIR" "$TEMP_DIR"
cd "$TEMP_DIR"

# Extract repo name from URL
REPO_NAME=$(basename "$REPO_URL")
EXTRACTED_DIR="${REPO_NAME}-main"

echo "Downloading $THEME_NAME..."
curl -L -o theme.zip "${REPO_URL}/archive/refs/heads/main.zip"
unzip -q theme.zip

cd "$EXTRACTED_DIR"
./install.sh

echo "Testing theme..."
hyprctl setcursor "$THEME_NAME" 24

if [ $? -eq 0 ]; then
    echo "Success! Theme applied."
else
    echo "Failed to apply theme"
fi

cd ~
rm -rf "$TEMP_DIR"
