#!/bin/bash

source "$(dirname "$0")/../utils/clone.sh"

add_plugin() {
  local repo="$1"
  [[ "$repo" != */* ]] && repo="zsh-users/$repo"
  clone_repo "$repo" "$HOME/.zsh/$(basename "$repo")"
}

add_plugin "zsh-syntax-highlighting"
add_plugin "zsh-autosuggestions"
