#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

omarchy-launch-terminal bash "$SCRIPT_DIR/nvim.sh" &>/dev/null &
"$SCRIPT_DIR/source-overwrites.sh"
