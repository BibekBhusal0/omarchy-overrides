#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
filePath="$scriptDir/files_to_copy/obsidian-elephant.lua"

cp "$filePath" "$HOME"/.config/elephant/menus/obsidian.lua
systemctl --user restart elephant
