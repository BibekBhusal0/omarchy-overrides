#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/write-to-file.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"

echo "Setting up Hyprland overrides..."
create_symlink "$SCRIPT_DIR/../files_to_copy/hyprland.lua" "$HOME/.config/hypr/own_config.lua"
write_to_file "$HOME/.config/hypr/hyprland.lua" "require(\"hypr.own_config\")"

echo ""

create_symlink "$SCRIPT_DIR/../files_to_copy/hyprsunset.conf" "$HOME/.config/hypr/hyprsunset.conf"
create_symlink "$SCRIPT_DIR/../files_to_copy/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# Setup bashrc/zsh overrides
echo "Setting up zsh overrides..."
write_to_file "$HOME/.zshrc" "source $SCRIPT_DIR/../zsh/rc.sh"

write_to_file "$HOME/.bashrc" "source $SCRIPT_DIR/../bash/rc.sh"

# env for uwsm
write_to_file "$HOME/.config/uwsm/env" "export PATH=$HOME/.cargo/bin:$HOME/.local/bin:\$PATH"

# Setup tmux overrides
echo "Setting up tmux overrides..."
write_to_file "$HOME/.config/tmux/tmux.conf" "source $SCRIPT_DIR/tmux.conf"

# Dynamic theme for starship and tmux
create_symlink "$SCRIPT_DIR/../files_to_copy/tmux-theme-hook.sh" "$HOME/.config/omarchy/hooks/theme-set.d/tmux.sh"
create_symlink "$SCRIPT_DIR/../files_to_copy/starship.toml.tpl" "$HOME/.config/omarchy/themed/starship.toml.tpl"
STARSHIP_THEMED="$HOME/.local/state/omarchy/current/theme/starship.toml"
if [ -f "$STARSHIP_THEMED" ]; then
  create_symlink "$STARSHIP_THEMED" "$HOME/.config/starship.toml"
else
  create_symlink "$SCRIPT_DIR/../files_to_copy/starship.toml" "$HOME/.config/starship.toml"
fi


write_to_file "$HOME/.XCompose" "include \"$SCRIPT_DIR/.XCompose\""
write_to_file "$HOME/.config/ghostty/config" "config-file= ?\"$SCRIPT_DIR/ghostty.config\""

echo ""
echo "Setup complete!"
