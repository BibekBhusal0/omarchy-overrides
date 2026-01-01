#!/bin/bash

# Chromium is uninstalled 
packages=(
    "1password-beta"
    "1password-cli"
    "docker"
    "docker-buildx"
    "docker-compose"
    "lazydocker"
    "ghostty"
    "obs-studio"
    "signal-desktop"
    "typora"
    "omarchy-chromium"
)

echo "Omarchy chromium is bing uninstalled make sure to change default browser"

for package in "${packages[@]}"; do
    echo "Removing $package..."
    yay -R "${package}" --noconfirm
done
