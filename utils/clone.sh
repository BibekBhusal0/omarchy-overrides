#!/bin/bash

clone() {
  local target="$1"
  shift

  [[ -z "$target" ]] && return 1
  
  target="${target%/}"
  target="${target#/}"

  local url=""
  if [[ "$target" =~ ^https?:// ]]; then
    # Full URL provided
    url="$target"
  elif [[ "$target" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9._-]+$ ]]; then
    # GitHub user/repo format
    url="https://github.com/$target"
  elif [[ "$target" =~ / ]]; then
    # Generic domain/repo format
    url="https://$target"
  else
    # Default to my repos
    url="https://github.com/bibekbhusal0/$target"
  fi

  local dest=""
  for arg in "$@"; do
    if [[ "$arg" != -* ]]; then
      dest="$arg"
      break
    fi
  done

  if [[ -n "$dest" ]]; then
    # Skip if destination exists
    [[ -d "$dest" ]] && return 0
    # ensure parent dir exists
    mkdir -p "$(dirname "$dest")"
  else
    # Skip if repo name exists in current dir
    local repo_name="${url##*/}"
    repo_name="${repo_name%.git}"
    [[ -d "$repo_name" ]] && return 0
  fi

  git clone "$url" "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  clone "$@"
fi
