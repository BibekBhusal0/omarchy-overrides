#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/utils/symlink.sh"
source "$REPO_ROOT/utils/write-to-file.sh"
create_symlink "$REPO_ROOT/bin" "$HOME/.local/my-bins"

write_to_file "$HOME/.config/uwsm/env" "PATH=\$HOME/.local/my-bins:\$PATH"
