#!/bin/bash

yay -Sy --noconfirm --needed brave-bin
yay -Sy --noconfirm --needed yazi
yay -Sy --noconfirm --needed legcord-bin
yay -Sy --noconfirm --needed opencode-bin
omarchy-install-dev-env node

npm install -g devmoji
npm install -g yarn
