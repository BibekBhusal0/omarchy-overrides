#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check and install required packages
echo "Checking required packages..."

echo "Installing required Python packages..."
pip3 install tomli tomli-w --break-system-packages 2>/dev/null || pip3 install tomli tomli-w

# Run the Python script
echo "Merging TOML files..."
python3 "$SCRIPT_DIR/toml/overwrite.py"

source "$SCRIPT_DIR/../utils/symlink.sh"
create_symlink "$SCRIPT_DIR/toml/overwrite-starship.toml" "$HOME/.config/starship.toml"

echo "Configuration complete!"
