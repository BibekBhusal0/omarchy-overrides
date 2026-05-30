#!/bin/bash

omarchy-pkg-aur-add bitwarden
omarchy-pkg-aur-add bitwarden-cli
omarchy-pkg-aur-add brave-bin
omarchy-pkg-aur-add helium-browser-bin
omarchy-pkg-aur-add hypruler-bin
omarchy-pkg-aur-add legcord-bin
omarchy-pkg-aur-add losslesscut-bin
omarchy-pkg-aur-add readest-git
omarchy-pkg-aur-add yazi

omarchy-install-dev-env bun
omarchy-install-dev-env node
omarchy-install-dev-env python

npm install -g devmoji
npm install -g yarn

curl -sSL https://usegitai.com/install.sh | bash
