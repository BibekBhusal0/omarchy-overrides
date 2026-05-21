#!/bin/bash

file="$1"
overwrite="${2:-false}"

mkdir -p "$(dirname "$file")"

content_to_write=$(cat -)

file_exists=false
if [ -f "$file" ]; then
  file_exists=true
fi

if "$file_exists"; then
  existing_file_content=$(<"$file")
  if [[ "$existing_file_content" == *"$content_to_write"* ]]; then
    echo "Content already present in $file. Skipping ..."
    exit 0
  fi
fi

if [ "$overwrite" = "true" ]; then
  echo "$content_to_write" > "$file"
  echo "Overwritten $file"
else
  echo "$content_to_write" >> "$file"
  echo "Appended to: $file"
fi
