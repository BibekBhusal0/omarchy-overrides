#!/bin/bash

yay -Sy --noconfirm --needed spicitify-cli

# Adding path to bashrc
echo 'export PATH=$PATH:~/.spicetify' >> ~/.bashrc
source ~/.bashrc

# Adding market palce
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
