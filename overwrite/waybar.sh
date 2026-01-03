#!/bin/bash
configDir="$HOME/.config/waybar/"
backupDir="$HOME/.config/waybar.backup"
currentDir=$(pwd)
newConfigDir="$currentDir/waybar"

if [ -d "$backupDir" ]; then
    rm -rf "$backupDir"
fi

mv "$configDir" "$backupDir"
cp -R "$newConfigDir" "$configDir"

# Restart waybar
omarchy-restart-waybar
