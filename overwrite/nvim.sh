#!/bin/bash
# Remove the default configuration for neovim and add my custom config instead

CONFIG_DIR="$HOME/.config/nvim" 
CONFIG_BACKUP_DIR="$HOME/.config/nvim.backup"
NEOVIM_CACHE_DIR="$HOME/.local/share/nvim"
USERNAME="BibekBhusal0"
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

git clone "https://github.com/$USERNAME/neovim-kickstart-config-config" "$CONFIG_DIR"
echo "Config replaced sucessfully"

# Other packages required for my neovim config 
pacman -S sqlite

# Cloning my other plugins different directory
# Because I might need to edit them
mkdir -p -- "$MY_PLUGINS_DIR"

for repo in "${REPOS[@]}"; do
  dest="$MY_PLUGINS_DIR/$repo"
  repo_url="https://github.com/${USERNAME}/${repo}.git"

  if [ -d "$dest/.git" ]; then
    printf '%s already cloned — skipping: %s\n' "$repo" "$dest"
    continue
  fi

  if [ -e "$dest" ] && [ ! -d "$dest" ]; then
    printf 'Path exists and is not a directory — skipping: %s\n' "$dest"
    continue
  fi

  if [ -d "$dest" ] && [ ! -d "$dest/.git" ]; then
    printf 'Directory exists but is not a git repo — creating backup and cloning: %s\n' "$dest"
    mv -- "$dest" "${dest}.bak.$(date +%s)"
  fi

  printf 'Cloning %s into %s\n' "$repo_url" "$dest"
  git clone --depth 1 "$repo_url" "$dest"
done
