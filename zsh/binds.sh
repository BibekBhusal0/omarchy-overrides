fzf-tab-command-widget() {
  local cmd

  if [[ "$LBUFFER" == ./* ]]; then
    zle fzf-file-widget
    return
  fi

  if [[ "$LBUFFER" == *[[:space:]]* ]]; then
    zle fzf-completion
    return
  fi

  cmd=$(print -rl -- ${(k)commands} ${(k)aliases} ${(k)functions} \
    | grep -v '^_' | sort -u \
    | fzf --height=40% --layout=reverse --margin=1 --prompt="" --query="$LBUFFER")
  if [[ -n "$cmd" ]]; then
    LBUFFER="$cmd"
    RBUFFER=""
  fi
  zle reset-prompt
}

zle -N fzf-tab-command-widget
bindkey '^I' fzf-tab-command-widget
