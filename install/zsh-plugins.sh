#!/bin/bash

add_plugin() {
  local plugin_name="$1"
  local base_path="$HOME/.oh-my-zsh/custom/plugins"

  # Full URL provided
  if [[ "$plugin_name" =~ ^https?:// ]]; then
    repo_url="$plugin_name"
    plugin_dir="${base_path}/$(basename "$repo_url" .git)"
  # Username/reponame format
  elif [[ "$plugin_name" =~ / ]]; then
    repo_url="https://github.com/${plugin_name}.git"
    plugin_dir="${base_path}/$(basename "$repo_url" .git)"
  # use zsh-users owner if only name is provided
  else
    repo_url="https://github.com/zsh-users/${plugin_name}.git"
    plugin_dir="${base_path}/$(basename "$repo_url" .git)"
  fi

  # Check if the plugin directory already exists
  if [ -d "$plugin_dir" ]; then
    echo "Plugin directory $plugin_dir already exists. Skipping..."
  else
    git clone "$repo_url" "$plugin_dir"
  fi
}

add_plugin "zsh-syntax-highlighting"
add_plugin "zsh-autosuggestions"
