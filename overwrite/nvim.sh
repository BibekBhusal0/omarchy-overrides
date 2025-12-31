#!/bin/bash
# Remove the default configuration for neovim and add my custom config instead


configDir="~/.config/nvim" 
configBackupDir="~/.config/nvim.backup"
mv $configDir $configBackupDir
echo "Overweriting neovim configuration orignal config backed up at $configBackupDir"

mkdir configDir
cd configDir

git clone "https://github.com/BibekBhusal0/neovim-kickstart-config-config"
