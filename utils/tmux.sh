#!/bin/bash

in_tmux() {
    [ -n "$TMUX" ]
}

# Collapse $HOME to ~ for display purposes.
tmux_display_path() {
    local p=${1/#$HOME/\~}
    printf '%s\n' "$p"
}

# Canonicalize a path for directory comparison.
tmux_canonical_path() {
    local p=$1
    if command -v realpath >/dev/null 2>&1; then
        realpath -m "$p" 2>/dev/null || printf '%s\n' "$p"
    else
        p=${p%/}
        printf '%s\n' "${p:-/}"
    fi
}

# Print all panes' starting directories for a session (one per line, deduped).
# Start paths are stable even after the user cds elsewhere or renames.
tmux_session_cwds() {
    tmux list-panes -a -F '#{session_name}	#{pane_start_path}' 2>/dev/null |
      awk -F '\t' -v s="$1" '$1==s && $2!="" {print $2}' | sort -u
}

# Print the session backed by the given directory (empty if none).
# Identity is directory-based, so renames don't break the match.
tmux_session_for_dir() {
    local canon s p
    canon=$(tmux_canonical_path "$1")
    tmux list-panes -a -F '#{session_name}	#{pane_start_path}' 2>/dev/null |
      while IFS=$'\t' read -r s p; do
        [ -n "$s" ] && [ -n "$p" ] || continue
        if [ "$(tmux_canonical_path "$p")" = "$canon" ]; then
            printf '%s\n' "$s"
            break
        fi
      done
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

# Find a free session name based on $1, suffixing (-1, -2, ...) on collision.
# tmux names must be unique, so same-named directories share a base name only.
tmux_unique_session_name() {
    local base=$1 name=$1 i=1
    while tmux has-session -t "$name" 2>/dev/null; do
        name="$base-$i"
        i=$((i + 1))
    done
    printf '%s\n' "$name"
}

create_or_switch_session() {
    local dir=$1 session_name desired
    dir=$(tmux_canonical_path "$dir")
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' does not exist." >&2
        return 1
    fi

    # Directory-based: reuse the session already backing this directory
    # (renames included — identity is the start path, not the name).
    session_name=$(tmux_session_for_dir "$dir")
    if [ -n "$session_name" ]; then
        switch_to "$session_name"
        return $?
    fi

    if [ -f "$dir/.tmuxinator.yml" ] && command -v tmuxinator >/dev/null 2>&1; then
        desired=$(grep -m1 '^name:' "$dir/.tmuxinator.yml" 2>/dev/null | sed 's/^name:[[:space:]]*//')
        desired=${desired:-$(basename "$dir" | tr . _)}
        session_name=$(tmux_unique_session_name "$desired")
        if [ "$session_name" = "$desired" ]; then
            (cd "$dir" && tmuxinator start .)
        else
            # Same name, different directory: keep both via a suffixed name.
            (cd "$dir" && tmuxinator start . -n "$session_name")
        fi
    else
        session_name=$(tmux_unique_session_name "$(basename "$dir" | tr . _)")
        tmux new-session -d -s "$session_name" -c "$dir"
    fi
    switch_to "$session_name"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is meant to be sourced, not executed directly."
fi
