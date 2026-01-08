#!/usr/bin/env bash
# Copying files from ../bin to ~/.local/bin
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_BIN="$REPO_ROOT/bin"
DST_BIN="/usr/bin"

mkdir -p "$DST_BIN"

for file in "$SRC_BIN"/*; do
    ln -sf "$file" "$DST_BIN/$(basename "$file")"
    chmod +x "$file"
done

echo "Bins installed to $DST_BIN"
