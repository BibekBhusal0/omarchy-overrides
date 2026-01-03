#!/bin/bash
configDir="$HOME/.config/waybar/"
backupDir="$HOME/.config/waybar.backup"
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
newConfigDir="$scriptDir/waybar"

if [ -d "$backupDir" ]; then
    rm -rf "$backupDir"
fi

mv "$configDir" "$backupDir"
cp -R "$newConfigDir" "$configDir"

# Restart waybar
omarchy-restart-waybar
