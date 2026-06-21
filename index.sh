#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/uninstall/all.sh"
"$SCRIPT_DIR/install/all.sh"
"$SCRIPT_DIR/overwrite/all.sh"
"$SCRIPT_DIR/git-config.sh"
