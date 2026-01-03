#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check and install required packages
echo "Checking required packages..."

REQUIRED_PACKAGES=(
    "python"
    "python-tomli"
    "python-tomli-w"
)

PACKAGES_TO_INSTALL=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        PACKAGES_TO_INSTALL+=("$pkg")
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing missing packages: ${PACKAGES_TO_INSTALL[*]}"
    sudo pacman -S --noconfirm --needed "${PACKAGES_TO_INSTALL[@]}"
else
    echo "All required packages are installed"
fi

# Run the Python script
echo "Merging TOML files..."
python3 "$SCRIPT_DIR/toml/overwrite.py"

omarchy-restart-walker

echo "Configuration complete!"
