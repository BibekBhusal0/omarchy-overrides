#!/bin/bash

clone() {
  local item_name="$1"
  local base_path="$2"

  # Full URL
  if [[ "$item_name" =~ ^https?:// ]]; then
    repo_url="$item_name"
    item_dir="${base_path}/$(basename "$repo_url" .git)"
  # Username/reponame format
  elif [[ "$item_name" =~ / ]]; then
    repo_url="https://github.com/${item_name}.git"
    item_dir="${base_path}/$(basename "$repo_url" .git)"
  # Defaults to zsh-users owner
  else
    repo_url="https://github.com/zsh-users/${item_name}.git"
    item_dir="${base_path}/$(basename "$repo_url" .git)"
  fi

  # Check if the item directory already exists
  if [ -d "$item_dir" ]; then
    echo "$item_name directory $item_dir already exists. Skipping..."
  else
    git clone "$repo_url" "$item_dir"
  fi
}

add_plugin() {
  clone "$1" "$HOME/.oh-my-zsh/custom/plugins"
}

add_theme() {
  clone "$1" "$HOME/.oh-my-zsh/themes"
}

add_plugin "zsh-syntax-highlighting"
add_plugin "zsh-autosuggestions"
add_theme "romkatv/powerlevel10k"
