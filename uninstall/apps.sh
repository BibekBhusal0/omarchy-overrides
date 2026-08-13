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

echo "Omarchy chromium is being uninstalled make sure to change default browser"

for package in "${packages[@]}"; do
    echo "Removing $package..."
    yay -R "${package}" --noconfirm
done

rm $HOME/.local/share/applications/Docker.desktop
rm $HOME/.local/share/applications/typora.desktop
