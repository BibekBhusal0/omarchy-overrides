#!/bin/bash

yay -Sy --noconfirm --needed brave-bin
yay -Sy --noconfirm --needed yazi
yay -Sy --noconfirm --needed legcord-bin
yay -Sy --noconfirm --needed hypruler-bin
yay -Sy --noconfirm --needed losslesscut-bin
yay -Sy --noconfirm --needed bitwarden
yay -Sy --noconfirm --needed bitwarden-cli
omarchy-install-dev-env node
omarchy-install-dev-env bun
omarchy-install-dev-env python

npm install -g devmoji
npm install -g yarn

curl -sSL https://usegitai.com/install.sh | bash
