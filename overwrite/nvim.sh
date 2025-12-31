#!/bin/bash
# Remove the default configuration for neovim and add my custom config instead

configDir="$HOME/.config/nvim" 
configBackupDir="$HOME/.config/nvim.backup"
neovimCacheDir="$HOME/.local/share/nvim"

echo "Overweriting neovim configuration"
if [ -d "$configDir" ]; then
  mv $configDir $configBackupDir
  echo "config backed up at $configBackupDir"
else 
  echo "No existing neovim config"
  exit 1
fi

if [ -d "$neovimCacheDir" ]; then
    rm -rf "$neovimCacheDir"
    echo "Removed existing Neovim cache at $neovimCacheDir"
fi

git clone "https://github.com/BibekBhusal0/neovim-kickstart-config-config" "$configDir"
echo "Config replaced sucessfully"
