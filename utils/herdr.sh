#!/bin/bash

HERDR_SPREADER="${HERDR_SPREADER:-herdr-spreader}"

in_herdr() {
    [ -n "${HERDR_ENV:-}" ]
}

herdr_current_workspace_id() {
    printf '%s\n' "${HERDR_ACTIVE_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}"
}

# Print the workspace id for a given label (empty if not found).
herdr_workspace_id() {
    local json re
    json=$(herdr workspace list 2>/dev/null) || return 0
    re='"label":"([^"]*)"[^}]*"workspace_id":"([^"]+)"'
    while [[ $json =~ $re ]]; do
        if [ "${BASH_REMATCH[1]}" = "$1" ]; then
            printf '%s\n' "${BASH_REMATCH[2]}"
            return 0
        fi
        json=${json#*"${BASH_REMATCH[0]}"}
    done
}

# Print the focused pane id of a workspace (falls back to its first pane).
herdr_focused_pane() {
    local json re
    json=$(herdr pane list --workspace "$1" 2>/dev/null) || return 0
    re='"focused":true[^}]*"pane_id":"([^"]+)"'
    if [[ $json =~ $re ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"
        return 0
    fi
    re='"pane_id":"([^"]+)"'
    [[ $json =~ $re ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}

# Capture recent output of a workspace's focused pane (tmux capture-pane equivalent).
herdr_capture_workspace() {
    local workspace_id=$1 pane
    pane=$(herdr_focused_pane "$workspace_id") || return 0
    [ -n "$pane" ] && herdr pane read "$pane" --lines 80 --format text 2>/dev/null
}

# Print "label<TAB>id" for every open workspace.
herdr_list_workspaces() {
    local json re
    json=$(herdr workspace list 2>/dev/null) || return 0
    re='"label":"([^"]*)"[^}]*"workspace_id":"([^"]+)"'
    while [[ $json =~ $re ]]; do
        printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        json=${json#*"${BASH_REMATCH[0]}"}
    done
}

# Find a herdr.yml/herdr.yaml in a directory; prints its path or nothing.
herdr_layout_file() {
    local dir=$1 f
    for f in herdr.yml herdr.yaml; do
        [ -f "$dir/$f" ] && { printf '%s\n' "$dir/$f"; return 0; }
    done
}

# Read `name:` of the first workspace from a spreader layout file.
herdr_layout_name() {
    sed -n 's/^[[:space:]]*-[[:space:]]*name:[[:space:]]*//p' "$1" | head -1 |
      sed 's/^"\(.*\)"$/\1/; s/^'"'"'\(.*\)'"'"'$/\1/'
}

# Print "name<TAB>dir" for every zoxide-known directory containing a layout.
herdr_list_projects() {
    local d layout name
    zoxide query -l 2>/dev/null | while IFS= read -r d; do
        [ -n "$d" ] || continue
        layout=$(herdr_layout_file "$d")
        [ -n "$layout" ] || continue
        name=$(herdr_layout_name "$layout")
        printf '%s\t%s\n' "${name:-${d##*/}}" "$d"
    done
}

# Print all pane cwds of a workspace (one per line, deduplicated).
herdr_workspace_cwds() {
    herdr pane list --workspace "$1" 2>/dev/null |
      grep -o '"cwd":"[^"]*"' | sed 's/"cwd":"//; s/"$//' | sort -u
}

# Canonicalize a path for directory comparison.
herdr_canonical_path() {
    local p=$1
    if command -v realpath >/dev/null 2>&1; then
        realpath -m "$p" 2>/dev/null || printf '%s\n' "$p"
    else
        p=${p%/}
        printf '%s\n' "${p:-/}"
    fi
}

# Print the workspace id whose panes were launched from the given directory
# (empty if none). Identity is directory-based so workspaces may share labels.
herdr_workspace_id_for_dir() {
    local dir canon row id cwd ccanon
    canon=$(herdr_canonical_path "$1")
    while IFS= read -r row; do
        [ -n "$row" ] || continue
        id=${row#*$'\t'}
        while IFS= read -r cwd; do
            [ -n "$cwd" ] || continue
            ccanon=$(herdr_canonical_path "$cwd")
            if [ "$ccanon" = "$canon" ]; then
                printf '%s\n' "$id"
                return 0
            fi
        done <<< "$(herdr_workspace_cwds "$id")"
    done <<< "$(herdr_list_workspaces)"
}

# Collapse $HOME to ~ for display purposes.
herdr_display_path() {
    local p=${1/#$HOME/\~}
    printf '%s\n' "$p"
}

switch_to_workspace() {
    local target=$1 id
    # A raw workspace id focuses directly.
    if herdr_list_workspaces | awk -F '\t' -v id="$target" '$2==id{found=1} END{exit !found}'; then
        herdr workspace focus "$target"
        return $?
    fi
    id=$(herdr_workspace_id "$target")
    if [ -n "$id" ]; then
        herdr workspace focus "$id"
    else
        echo "No herdr workspace named '$target'." >&2
        return 1
    fi
}

# Create a workspace for a directory or switch to the one already backing it.
# Matching is directory-based: directories sharing a layout `name:` (or
# basename) each get their own workspace even with duplicate labels.
create_or_switch_workspace() {
    local dir=$1 layout name existing before after new_id out
    # Backwards compat: a workspace id or label focuses directly.
    if [ ! -d "$dir" ]; then
        if [ -n "$dir" ]; then
            if herdr_list_workspaces | awk -F '\t' -v id="$dir" '$2==id{found=1} END{exit !found}'; then
                herdr workspace focus "$dir"
                return $?
            fi
            if [ -n "$(herdr_workspace_id "$dir")" ]; then
                switch_to_workspace "$dir"
                return $?
            fi
        fi
        echo "Error: Directory '$dir' does not exist." >&2
        return 1
    fi

    dir=$(herdr_canonical_path "$dir")

    existing=$(herdr_workspace_id_for_dir "$dir")
    if [ -n "$existing" ]; then
        herdr workspace focus "$existing"
        return $?
    fi

    layout=$(herdr_layout_file "$dir")
    if [ -n "$layout" ] && command -v "$HERDR_SPREADER" >/dev/null 2>&1; then
        name=$(herdr_layout_name "$layout")
        name="${name:-$(basename "$dir" | tr . _)}"
        before=$(herdr_list_workspaces | cut -f2 | sort -u)
        # cd into the project and drop HERDR_PANE_ID so spreader's default
        # root becomes the project dir even without `root:` in the layout.
        (cd "$dir" && env -u HERDR_PANE_ID "$HERDR_SPREADER" apply --file "$layout") || return 1
        after=$(herdr_list_workspaces)
        # The fresh workspace is the id that did not exist before; fall back
        # to directory lookup, then to label, if the diff comes up empty.
        new_id=$(printf '%s\n' "$after" | cut -f2 | sort -u | comm -23 - <(printf '%s\n' "$before") | head -1)
        if [ -z "$new_id" ]; then
            new_id=$(herdr_workspace_id_for_dir "$dir")
        fi
        if [ -n "$new_id" ]; then
            herdr workspace focus "$new_id"
        else
            switch_to_workspace "$name"
        fi
    else
        name=$(basename "$dir" | tr . _)
        out=$(herdr workspace create --cwd "$dir" --label "$name") || return 1
        new_id=$(printf '%s\n' "$out" | grep -o '"workspace_id":"[^"]*"' | head -1 | sed 's/"workspace_id":"//; s/"$//')
        if [ -n "$new_id" ]; then
            herdr workspace focus "$new_id"
        else
            switch_to_workspace "$name"
        fi
    fi
}

# Accepts a workspace label or a raw workspace id.
close_workspace() {
    local target=$1 id
    [ -n "$target" ] || return 0
    id=$(herdr_workspace_id "$target")
    herdr workspace close "${id:-$target}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is meant to be sourced, not executed directly."
fi
