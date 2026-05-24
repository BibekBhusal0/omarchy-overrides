#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_BIN="$REPO_ROOT/bin"
DST_BIN="$HOME/.local/bin"

# If destination exists and is a directory but not a symlink, remove it
if [ -d "$DST_BIN" ] && [ ! -L "$DST_BIN" ]; then
  echo "Not symlink removing directory"
  rm -rf "$DST_BIN"
fi

# Ensure parent directory exists
mkdir -p "$(dirname "$DST_BIN")"

ln -sfn "$SRC_BIN" "$DST_BIN"
echo "Symlink created: $SRC_BIN -> $DST_BIN"
