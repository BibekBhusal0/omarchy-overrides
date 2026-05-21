#!/bin/bash
configDir="$HOME/.config/waybar/"
backupDir="$HOME/.config/waybar.backup"
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
newConfigDir="$scriptDir/../files_to_copy/waybar"

if [ -d "$backupDir" ]; then
    rm -rf "$backupDir"
fi

if [ -d "$configDir" ]; then
  mv "$configDir" "$backupDir"
fi

cp -R "$newConfigDir" "$configDir"

# Restart waybar
omarchy-restart-waybar
