# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

attach_tmux=$([[ -n "$TMUX" || -n "$NO_TMUX" || "$TERM" = "screen" ]])
if ! $attach_tmux; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

SCRIPT_DIR="${0:A:h}"

source "$SCRIPT_DIR/alias.sh"
source "$SCRIPT_DIR/binds.sh"
source "$SCRIPT_DIR/plugins.sh"
source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/oh-my-zsh"

# Attach to latest tmux session or create new if it don't exist
if $attach_tmux; then
  tmux new-session -As main
fi
