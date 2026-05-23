#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_BIN="$REPO_ROOT/bin"
DST_BIN="$HOME/.local/bin"

mkdir -p "$DST_BIN"

if [ -d "$SRC_BIN" ] && [ -n "$(ls -A "$SRC_BIN" 2>/dev/null)" ]; then
    chmod +x "$SRC_BIN"/*
    ln -sfn "$SRC_BIN"/* "$DST_BIN/"
fi

echo "Bins symlinked to $DST_BIN"
