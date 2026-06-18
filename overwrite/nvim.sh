#!/bin/bash

# Remove the default configuration for neovim and add my custom config instead
CONFIG_DIR="$HOME/.config/nvim" 
CONFIG_BACKUP_DIR="$HOME/.config/nvim.backup"
NEOVIM_CACHE_DIR="$HOME/.local/share/nvim"
MY_PLUGINS_DIR="${HOME}/Code/nvim-plugins"
REPOS=(
  "bufstack.nvim"
  "nvim-git-utils"
  "nvim-shadcn"
  "tree-hierarchy.nvim"
)

echo "Overweriting neovim configuration"
if [ -d "$CONFIG_DIR" ]; then
  mv "$CONFIG_DIR" "$CONFIG_BACKUP_DIR"
  echo "config backed up at $CONFIG_BACKUP_DIR"
else 
  echo "No existing neovim config"
  exit 1
fi

if [ -d "$NEOVIM_CACHE_DIR" ]; then
    rm -rf "$NEOVIM_CACHE_DIR"
    echo "Removed existing Neovim cache at $NEOVIM_CACHE_DIR"
fi

source "$(dirname "$0")/../utils/clone.sh"
clone "neovim-kickstart-config-config" "$CONFIG_DIR"
echo "Config replaced sucessfully"

# Cloning my other plugins different directory
# Because I might need to edit them
mkdir -p -- "$MY_PLUGINS_DIR"

for repo in "${REPOS[@]}"; do
  clone "$repo" "$MY_PLUGINS_DIR/$repo"
done

./install/nvim-plugins.sh
