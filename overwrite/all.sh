#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/nvim.sh"
"$SCRIPT_DIR/overwrite-toml.sh"
"$SCRIPT_DIR/source-overwrites.sh"
"$SCRIPT_DIR/waybar.sh"
