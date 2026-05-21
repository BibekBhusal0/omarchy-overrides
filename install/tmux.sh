#!/bin/bash
# file inspired from https://github.com/typecraft-dev/omarchy-supplement/blob/main/install-tmux.sh

# Now omarchy has tmux preinstalled
# if ! command -v tmux &>/dev/null; then
#   yay -S --noconfirm --needed tmux
# fi

source "$(dirname "$0")/../utils/clone.sh"
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "Installing Tmux Plugin Manager (TPM)..."
clone_repo https://github.com/tmux-plugins/tpm "$TPM_DIR"

echo "TPM installed successfully!"

# Install tmuxinator
yay -Sy --noconfirm --needed tmuxinator

# Installing plugins
~/.tmux/plugins/tpm/bin/install_plugins || true
