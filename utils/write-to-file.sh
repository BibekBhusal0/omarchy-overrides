#!/bin/bash

write_to_file() {
  local file="$1"
  local content="$2"
  local overwrite="${3:-false}"

  [[ -z "$file" || -z "$content" ]] && return 1

  mkdir -p "$(dirname "$file")"

  if [[ -f "$file" ]]; then
    local existing_content=$(<"$file")
    if [[ "$existing_content" == *"$content"* ]]; then
      echo "Content already present in $file. Skipping..."
      return 0
    fi
  fi

  if [[ "$overwrite" == "true" ]]; then
    echo "$content" > "$file"
    echo "Overwritten: $file"
  else
    echo "$content" >> "$file"
    echo "Appended to: $file"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  content=$(cat -)
  write_to_file "$1" "$content" "$2"
fi
