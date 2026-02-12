# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

attach_tmux=0
if [[ -z "$TMUX" && -z "$NO_TMUX" && -z "$NVIM" && "$TERM" != "screen" ]]; then
  attach_tmux=1
fi

if (( ! attach_tmux )); then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

SCRIPT_DIR="${0:A:h}"

source "$SCRIPT_DIR/plugins.sh"
source "$SCRIPT_DIR/oh-my-zsh"

source "$SCRIPT_DIR/alias.sh"
source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/binds.sh"

# Attach or create tmux session
if (( attach_tmux )); then
  tmux new-session -As main
fi
