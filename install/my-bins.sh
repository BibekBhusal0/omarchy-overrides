#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/utils/symlink.sh"
create_symlink "$REPO_ROOT/bin" "$HOME/.local/bin"
