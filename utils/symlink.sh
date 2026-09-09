#!/bin/bash

create_symlink() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ] && [ "$(readlink -m "$dest")" == "$(readlink -m "$src")" ]; then
    echo "Symlink already correct: $dest"
    return
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing file: $dest"
    mv "$dest" "$dest.bak"
  fi

  echo "Linking $src -> $dest"
  mkdir -p "$(dirname "$dest")" && ln -sfn "$src" "$dest"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  create_symlink "$@"
fi
