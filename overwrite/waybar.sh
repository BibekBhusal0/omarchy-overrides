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

mkdir -p ~/.config/waybar/scripts ~/.config/waybar/sounds && \
curl -L https://raw.githubusercontent.com/nirabyte/waybar-timer/main/timer.sh -o ~/.config/waybar/scripts/timer.sh && \
curl -L https://raw.githubusercontent.com/nirabyte/waybar-timer/main/sounds/timer.mp3 -o ~/.config/waybar/sounds/timer.mp3 && \
chmod +x ~/.config/waybar/scripts/timer.sh

# Restart waybar
omarchy-restart-waybar
