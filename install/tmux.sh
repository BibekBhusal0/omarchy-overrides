#!/bin/bash
# file inspired from https://github.com/typecraft-dev/omarchy-supplement/blob/main/install-tmux.sh

if ! command -v tmux &>/dev/null; then
  yay -S --noconfirm --needed tmux
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
  echo "TPM is already installed in $TPM_DIR"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "TPM installed successfully!"

# Install tmuxinator
yay -Sy --noconfirm --needed tmuxinator
