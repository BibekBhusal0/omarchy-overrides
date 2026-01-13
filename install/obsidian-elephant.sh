#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
filePath="$scriptDir/files_to_copy/obsidian-elephant.lua"

iconDir="$HOME/.config/elephant/icons"
mkdir -p "$iconDir"

curl -sL -o "$iconDir/obsidian-note.svg" "https://raw.githubusercontent.com/saoudi-h/solar-icons/refs/heads/main/packages/core/svgs/notes/BoldDuotone/notes.svg"
curl -sL -o "$iconDir/obsidian-canvas.svg" "https://raw.githubusercontent.com/saoudi-h/solar-icons/refs/heads/main/packages/core/svgs/messages/BoldDuotone/pen-new-square.svg"
curl -sL -o "$iconDir/obsidian-base.svg" "https://raw.githubusercontent.com/saoudi-h/solar-icons/refs/heads/main/packages/core/svgs/ui/BoldDuotone/database.svg"
curl -sL -o "$iconDir/obsidian-add.svg" "https://raw.githubusercontent.com/saoudi-h/solar-icons/refs/heads/main/packages/core/svgs/notes/BoldDuotone/clipboard-add.svg"

THEME_COLOR="#BAA4E6"
sed -i "s/fill=\"[^\"]*\"/fill=\"$THEME_COLOR\"/g" "$iconDir"/*.svg

cp "$filePath" "$HOME"/.config/elephant/menus/obsidian.lua
systemctl --user restart elephant
omarchy-restart-walker
