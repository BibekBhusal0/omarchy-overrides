#!/bin/bash

in_tmux() {
    [ -n "$TMUX" ]
}

switch_to() {
    local target=$1
    if in_tmux; then
        tmux switch-client -t "$target"
    else
        tmux attach-session -t "$target"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is meant to be sourced, not executed directly."
fi
