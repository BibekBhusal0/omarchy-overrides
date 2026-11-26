#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

# Install Flea
omarchy-pkg-add flea
flea --picker

create_symlink "$SCRIPT_DIR/../files_to_copy/flea-keys.toml" "$HOME/.config/flea/keys.toml"
