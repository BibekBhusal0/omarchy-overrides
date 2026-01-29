#!/bin/bash

yay -Sy --noconfirm --needed brave-bin
yay -Sy --noconfirm --needed yazi
yay -Sy --noconfirm --needed legcord-bin
yay -Sy --noconfirm --needed opencode-bin
yay -Sy --noconfirm --needed hypruler-bin
yay -Sy --noconfirm --needed losslesscut-bin
omarchy-install-dev-env node

npm install -g devmoji
npm install -g yarn
npm install -g bun

git config --global alias.logg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short"

sudo pacman -S --noconfirm asciinema
yay -Sy --noconfirm --needed asciinema-agg-bin

curl -sSL https://usegitai.com/install.sh | bash
