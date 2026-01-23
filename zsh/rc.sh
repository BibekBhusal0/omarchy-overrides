# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

SCRIPT_DIR="${0:A:h}"

source "$SCRIPT_DIR/alias.sh"
source "$SCRIPT_DIR/binds.sh"
source "$SCRIPT_DIR/init.sh"
source "$SCRIPT_DIR/plugins.sh"
source "$SCRIPT_DIR/shell.sh"

# This file contains default contents which oh my zsh added to my zshrc
source "$SCRIPT_DIR/oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
