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

create_or_switch_session() {
    local dir=$1
    local session_name
    session_name=$(basename "$dir" | tr . _)

    if [ -f "$dir/.tmuxinator.yml" ] && command -v tmuxinator >/dev/null 2>&1; then
        (cd "$dir" && tmuxinator start .)
    else
        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            tmux new-session -d -s "$session_name" -c "$dir"
        fi
        switch_to "$session_name"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is meant to be sourced, not executed directly."
fi
