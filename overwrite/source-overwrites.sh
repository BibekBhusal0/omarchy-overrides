#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRITE_TO_FILE="$SCRIPT_DIR/../utils/write-to-file.sh"

chmod +x "$WRITE_TO_FILE"

echo "Setting up Hyprland overrides..."
"$WRITE_TO_FILE" "$HOME/.config/hypr/hyprlock.conf" <<< "source = $SCRIPT_DIR/hyprlock.overwrite.conf"

echo ""

# Setup bashrc/zsh overrides
echo "Setting up zsh overrides..."
"$WRITE_TO_FILE" "$HOME/.zshrc" <<< "source $SCRIPT_DIR/../zsh/rc.sh"

"$WRITE_TO_FILE" "$HOME/.bashrc" <<EOF
source $SCRIPT_DIR/bashrc
source $SCRIPT_DIR/../zsh/shell.sh
source $SCRIPT_DIR/../zsh/alias.sh
EOF

# env for uwsm
"$WRITE_TO_FILE" "$HOME/.config/uwsm/env" <<< "export PATH=$HOME/.cargo/bin:$HOME/.local/bin:\$PATH"

# Setup tmux overrides
echo "Setting up tmux overrides..."
"$WRITE_TO_FILE" "$HOME/.tmux.conf" <<< "source $SCRIPT_DIR/tmux.conf"
tmux source ~/.tmux.conf

"$WRITE_TO_FILE" "$HOME/.XCompose" <<< "include \"$SCRIPT_DIR/.XCompose\""

echo ""
echo "Setup complete!"
