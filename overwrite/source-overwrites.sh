#!/bin/bash
# Inspired by: https://github.com/typecraft-dev/omarchy-supplement/blob/main/install-hyprland-overrides.sh

set -e

add_source_to_config() {
    local config_file="$1"
    local source_line="$2"

    # Create config file if it doesn't exist
    if [ ! -f "$config_file" ]; then
        echo "Config file not found at $config_file"
        echo "Creating config file..."
        mkdir -p "$(dirname "$config_file")"
        touch "$config_file"
        echo "Config file created at $config_file"
    fi
    
    # Check if source line already exists
    if grep -Fxq "$source_line" "$config_file"; then
        echo "Source line already exists in $config_file"
        return 0
    fi

    # Add source line to config
    echo "Adding source line to $config_file"
    echo "" >> "$config_file"
    echo "$source_line" >> "$config_file"
    echo "Source line added successfully to $config_file"

    return 0
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup Hyprland overrides
echo "Setting up Hyprland overrides..."
add_source_to_config "$HOME/.config/hypr/hyprland.conf" "source = $SCRIPT_DIR/hyprland.overwrite.conf"

echo "Setting up Hyprland overrides..."
add_source_to_config "$HOME/.config/hypr/hyprlock.conf" "source = $SCRIPT_DIR/hyprlock.overwrite.conf"

echo ""

# Setup bashrc overrides
echo "Setting up bashrc overrides..."
add_source_to_config "$HOME/.bashrc" "source $SCRIPT_DIR/bashrc"
# Making bin folder executable
[ -d "$SCRIPT_DIR/../bin" ] && chmod +x "$SCRIPT_DIR/../bin"/*

# env for uwsm
add_source_to_config "$HOME/.config/uwsm/env" "export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Setup tmux overrides
echo "Setting up tmux overrides..."
add_source_to_config "$HOME/.tmux.conf" "source $SCRIPT_DIR/tmux.conf"
tmux source ~/.tmux.conf


echo ""
echo "Setup complete!"
