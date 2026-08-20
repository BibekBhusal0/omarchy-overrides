#!/bin/bash

# Herdr is preinstalled in omarchy so no need to install it here

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

create_symlink "$SCRIPT_DIR/../files_to_copy/herdr.toml" "$HOME/.config/herdr/config.toml"
