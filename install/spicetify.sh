#!/bin/bash

yay -Sy --noconfirm --needed spicitify-cli

# Adding market palce
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
