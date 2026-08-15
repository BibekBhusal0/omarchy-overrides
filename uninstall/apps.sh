#!/bin/bash

omarchy-pkg-drop \
  libreoffice-fresh \
  xournalpp \
  pinta \
  obs-studio \
  kdenlive \
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
  lazydocker

echo "Omarchy chromium is being uninstalled make sure to change default browser"

rm $HOME/.local/share/applications/Docker.desktop
rm $HOME/.local/share/applications/typora.desktop
rm $HOME/.local/share/applications/Alacritty.desktop
