#!/bin/bash

in_tmux() {
    [ -n "$TMUX" ]
}

# Collapse $HOME to ~ for display purposes.
tmux_display_path() {
    local p=${1/#$HOME/\~}
    printf '%s\n' "$p"
}

# Print the first pane's path of a session (its creation directory).
tmux_session_cwds() {
    tmux list-panes -t "$1" -F '#{pane_current_path}' 2>/dev/null | head -1
}

# Print "name<TAB>dir" for every zoxide-known directory containing .tmuxinator.yml.
tmux_list_projects() {
    local d name
    zoxide query -l 2>/dev/null | while IFS= read -r d; do
        [ -n "$d" ] || continue
        [ -f "$d/.tmuxinator.yml" ] || continue
        name=$(grep -m1 '^name:' "$d/.tmuxinator.yml" 2>/dev/null | sed 's/^name:[[:space:]]*//')
        printf '%s\t%s\n' "${name:-${d##*/}}" "$d"
    done
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
