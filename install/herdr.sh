#!/bin/bash

# Herdr is preinstalled in omarchy so no need to install it here

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

create_symlink "$SCRIPT_DIR/../files_to_copy/herdr.toml" "$HOME/.config/herdr/config.toml"
create_symlink "$SCRIPT_DIR/../files_to_copy/herdr-automatic-rename.sh" "$HOME/.config/herdr-automatic-rename/config.sh"

install_plugin() {
  local name="${1##*/}"
  if ! herdr plugin list 2>/dev/null | grep -q "$name"; then
    herdr plugin install "$1" --yes
  fi
}

install_plugin ChmaraX/herdr-nvim
install_plugin qu8n/herdr-automatic-rename

if ! command -v herdr-spreader >/dev/null 2>&1; then
  cargo install --git https://github.com/yuk1ty/herdr-spreader
fi
