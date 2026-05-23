# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# source from Omarchy
export OMARCHY_PATH=$HOME/.local/share/omarchy
source $OMARCHY_PATH/default/bash/aliases
source $OMARCHY_PATH/default/bash/functions
source $OMARCHY_PATH/default/bash/envs

SCRIPT_DIR="${0:A:h}"

source "$SCRIPT_DIR/plugins.sh"
source "$SCRIPT_DIR/oh-my-zsh"

source "$SCRIPT_DIR/alias.sh"
source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/binds.sh"

eval "$(starship init zsh)"
