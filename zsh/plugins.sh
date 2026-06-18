# Interigation of ZSH with other tools
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh)"
fi

if (( ${+commands[fzf]} ));then
  eval "$(fzf --zsh)"
fi

# Some settings requied for zsh autosuggestions to work
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^[[1;5C' forward-word
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
