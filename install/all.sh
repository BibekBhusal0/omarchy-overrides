#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fast/simple scripts: run inline, no terminal needed
bash "$SCRIPT_DIR/cursor-theme.sh"
bash "$SCRIPT_DIR/my-bins.sh"
bash "$SCRIPT_DIR/webapp.sh"

# Long-running but AUR-free: launch in parallel terminals
omarchy-launch-terminal bash "$SCRIPT_DIR/herdr.sh" &>/dev/null &
omarchy-launch-terminal bash "$SCRIPT_DIR/lofi-music.sh" &>/dev/null &

# AUR scripts: must run sequentially to avoid pacman lock conflicts
omarchy-launch-terminal bash -c "
  bash '$SCRIPT_DIR/zsh.sh'
  bash '$SCRIPT_DIR/tmux.sh'
  bash '$SCRIPT_DIR/tui.sh'
  bash '$SCRIPT_DIR/spicetify.sh'
  bash '$SCRIPT_DIR/zen-browser.sh'
  bash '$SCRIPT_DIR/others.sh'
  bash '$SCRIPT_DIR/flatpak.sh' 
" &>/dev/null &
