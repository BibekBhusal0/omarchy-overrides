[[ $- == *i* ]] || return 0

command -v lxask &>/dev/null || return 0

if command -v flyline &>/dev/null; then
  _lxask_widget() {
    local out err line colour
    local -a frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

    colour=$(sed -n 's/^accent *= *"#\([0-9a-fA-F]\{6\}\)"/\1/p' \
      "$HOME/.local/state/omarchy/current/theme/colors.toml" 2>/dev/null)
    [[ -n $colour ]] && colour=$(printf '\033[38;2;%d;%d;%dm' \
      "0x${colour:0:2}" "0x${colour:2:2}" "0x${colour:4:2}")

    # Spinner runs in background; lxask runs in foreground so no job noise.
    local frame=0
    ( while true; do
        printf '\r\033[K%s%s\033[0m  thinking…' "$colour" "${frames[frame++ % 10]}"
        sleep 0.08
      done ) &
    local spinner_pid=$!

    out=$(mktemp) err=$(mktemp)
    lxask --command-only -- "$READLINE_LINE" >"$out" 2>"$err"
    kill "$spinner_pid" 2>/dev/null
    wait "$spinner_pid" 2>/dev/null
    printf '\r\033[K'

    line=$(<"$out")
    grep -v '^lxask: ready' "$err" >&2
    rm -f "$out" "$err"

    [[ -n $line ]] || return
    READLINE_LINE=$line
    READLINE_POINT=${#READLINE_LINE}
  }
  flyline key bind Ctrl+g 'always=runBashCommand(_lxask_widget)'
fi

alias ask='lxask'
alias cmd='lxask --no-explain'
alias explain='lxask --explain'
