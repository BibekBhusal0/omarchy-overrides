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
    local label=$1
    herdr workspace list 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for w in data.get("result", {}).get("workspaces", []):
    if w.get("label") == sys.argv[1]:
        print(w["workspace_id"])
        break
' "$label"
}

# Print the focused pane id of a workspace (falls back to its first pane).
herdr_focused_pane() {
    local workspace_id=$1
    herdr pane list --workspace "$workspace_id" 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
panes = data.get("result", {}).get("panes", [])
for p in panes:
    if p.get("focused"):
        print(p["pane_id"])
        break
else:
    if panes:
        print(panes[0]["pane_id"])
'
}

# Capture recent output of a workspace's focused pane (tmux capture-pane equivalent).
herdr_capture_workspace() {
    local workspace_id=$1 pane
    pane=$(herdr_focused_pane "$workspace_id") || return 0
    [ -n "$pane" ] && herdr pane read "$pane" --lines 80 --format text 2>/dev/null
}

# Print "label<TAB>id" for every open workspace.
herdr_list_workspaces() {
    herdr workspace list 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for w in data.get("result", {}).get("workspaces", []):
    label = w.get("label", "")
    print(label + "\t" + w["workspace_id"])
'
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

# Print the root pane's cwd of a workspace (its creation directory).
herdr_workspace_cwds() {
    herdr pane list --workspace "$1" 2>/dev/null |
      grep -o '"cwd":"[^"]*"' | sed 's/"cwd":"//; s/"$//' | head -1
}

# Collapse $HOME to ~ for display purposes.
herdr_display_path() {
    local p=${1/#$HOME/\~}
    printf '%s\n' "$p"
}

switch_to_workspace() {
    local target=$1 id
    id=$(herdr_workspace_id "$target")
    if [ -n "$id" ]; then
        herdr workspace focus "$id"
    else
        echo "No herdr workspace named '$target'." >&2
        return 1
    fi
}

create_or_switch_workspace() {
    local dir=$1 layout name
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' does not exist." >&2
        return 1
    fi

    layout=$(herdr_layout_file "$dir")
    if [ -n "$layout" ] && command -v "$HERDR_SPREADER" >/dev/null 2>&1; then
        name=$(herdr_layout_name "$layout")
        name="${name:-$(basename "$dir" | tr . _)}"
        # Re-applying would spawn a duplicate workspace; switch instead.
        if [ -z "$(herdr_workspace_id "$name")" ]; then
            # cd into the project and drop HERDR_PANE_ID so spreader's default
            # root becomes the project dir even without `root:` in the layout.
            (cd "$dir" && env -u HERDR_PANE_ID "$HERDR_SPREADER" apply --file "$layout") || return 1
        fi
    else
        name=$(basename "$dir" | tr . _)
        if [ -z "$(herdr_workspace_id "$name")" ]; then
            herdr workspace create --cwd "$dir" --label "$name" || return 1
        fi
    fi
    switch_to_workspace "$name"
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
