#!/bin/bash

# My fav theme Osaka Jade stopped shipping inside the Omarchy package at 4.5 so installing it manually
REPO_URL="https://github.com/omacom/omarchy-osaka-jade-theme"
THEME_DIR="$HOME/.config/omarchy/themes/osaka-jade"

if [[ -d "$THEME_DIR/.git" ]]; then
  echo "Osaka Jade already installed from $REPO_URL. Skipping..."
else
  omarchy theme install "$REPO_URL"
fi
