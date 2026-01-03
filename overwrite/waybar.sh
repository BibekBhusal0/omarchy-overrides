#!/bin/bash
configDir="$HOME/.config/waybar/"
backupDir="$HOME/.config/waybar.backup"
currentDir=$(pwd)
newConfigDir="$currentDir/waybar"

mv "$configDir" "$backupDir"
cp -R "$newConfigDir" "$configDir"

# Restart waybar
omarchy-restart-waybar
