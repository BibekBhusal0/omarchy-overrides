#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

omarchy-install-ai-t3-code stable --no-launch

create_symlink "$SCRIPT_DIR/../files_to_copy/t3code-keybindings.json" "$HOME/.t3/userdata/keybindings.json"
create_symlink "$SCRIPT_DIR/../files_to_copy/t3code-client-settings.json" "$HOME/.t3/userdata/client-settings.json"

echo "T3 Code installed and configured"
