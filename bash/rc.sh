echo "Using Bash Shell"

BASH_RC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$BASH_RC_DIR/../zsh"
source "$BASH_RC_DIR/../zsh/shell.sh"
source "$BASH_RC_DIR/../zsh/alias.sh"
source "$BASH_RC_DIR/flyline.sh"

fzf-command() {
  local cmd=$(compgen -c | fzf)
  if [[ -n $cmd ]]; then
    READLINE_LINE="$cmd"
    READLINE_POINT=${#READLINE_LINE}
  fi
}
bind -x '"\C-f": fzf-command'
