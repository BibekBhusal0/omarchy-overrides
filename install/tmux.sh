#!/bin/bash
# file inspired from https://github.com/typecraft-dev/omarchy-supplement/blob/main/install-tmux.sh

set -e

# Install tmux
yay -S --noconfirm --needed tmux

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
  echo "tmux installation failed."
  exit 1
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

TMUXIFIER_DIR="$HOME/.tmuxifier"
# Check if tmuxifier is already installed
if [ -d "$TMUXIFIER_DIR" ]; then
  echo "Tmuxifier is already installed in $TMUXIFIER_DIR"
else 
  echo "Installing Tmuxifier ..."
  git clone https://github.com/jimeh/tmuxifier.git "$TMUXIFIER_DIR"
fi
