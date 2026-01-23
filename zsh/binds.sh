fzf-command-widget() {
  local cmd=$(print -rl -- ${(k)commands} | fzf)
  if [[ -n $cmd ]]; then
    LBUFFER="$cmd"
    RBUFFER=""
  fi
  zle reset-prompt
}

zle -N fzf-command-widget
bindkey '^F' fzf-command-widget
