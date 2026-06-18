#!/bin/bash

packages=(
  "1password-beta"
  "1password-cli"
  "chromium"
  "docker"
  "docker-buildx"
  "docker-compose"
  "lazydocker"
  "obs-studio"
  "omarchy-chromium"
  "signal-desktop"
  "typora"
  "ufw-docker"
)

echo "Omarchy chromium is bing uninstalled make sure to change default browser"

for package in "${packages[@]}"; do
    echo "Removing $package..."
    yay -R "${package}" --noconfirm
done
