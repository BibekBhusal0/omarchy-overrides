#!/bin/bash

# Installing oh my zsh
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

source "$(dirname "$0")/../utils/clone.sh"

add_plugin() {
  local repo="$1"
  [[ "$repo" != */* ]] && repo="zsh-users/$repo"
  clone_repo "$repo" "$HOME/.oh-my-zsh/custom/plugins/$(basename "$repo")"
}

add_theme() {
  local repo="$1"
  [[ "$repo" != */* ]] && repo="zsh-users/$repo"
  clone_repo "$repo" "$HOME/.oh-my-zsh/themes/$(basename "$repo")"
}

add_plugin "zsh-syntax-highlighting"
add_plugin "zsh-autosuggestions"
