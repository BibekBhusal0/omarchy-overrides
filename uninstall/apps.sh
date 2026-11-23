#!/bin/bash

# Omarchy don't remove some desktop entries so removing them manually
remove_desktop_entry() {
  local entry="$HOME/.local/share/applications/$1"
  [[ -e "$entry" ]] && rm -f "$entry" && echo "Removed: $1"
}

omarchy-pkg-drop \
  libreoffice-fresh \
  pinta \
  moonlight-qt \
  omarchy-chromium \
  chromium \
  typora \
  1password-beta \
  1password-cli \
  docker \
  docker-buildx \
  docker-compose \
  signal-desktop \
  ufw-docker \
  lazydocker \
  omarchy-hyprland-titlebars \
  signed \
  fcitx5 \
  fcitx5-gtk \
  fcitx5-qt \
  fcitx5-configtool \
  fcitx5-chinese-addons \
  fcitx5-chewing \
  fcitx5-hangul \
  fcitx5-mozc \
  spotify \
  spicetify-cli

echo "Omarchy chromium is being uninstalled make sure to change default browser"

remove_desktop_entry Docker.desktop
remove_desktop_entry typora.desktop
remove_desktop_entry Alacritty.desktop
remove_desktop_entry signed.desktop
remove_desktop_entry spotify.desktop
