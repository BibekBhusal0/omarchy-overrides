# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/init.sh"
source "$SCRIPT_DIR/alias.sh"
source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/input.sh"
source "$SCRIPT_DIR/binds.sh"

source "$SCRIPT_DIR/plugins.sh"

# This file contains default contents which oh my zsh added to my zshrc
source "$SCRIPT_DIR/oh-my-zsh"
