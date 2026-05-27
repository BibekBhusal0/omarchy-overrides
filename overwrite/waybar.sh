#!/bin/bash
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$scriptDir/../utils/symlink.sh"
create_symlink "$scriptDir/../files_to_copy/waybar" "$HOME/.config/waybar"

# Restart waybar
omarchy-restart-waybar
