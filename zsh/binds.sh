fzf-command-widget() {
  local cmd=$(print -rl -- ${(k)commands} ${(k)aliases} | sort -u | fzf \
    --height=40% --layout=reverse --margin=1 --prompt="")
  if [[ -n $cmd ]]; then
    LBUFFER="$cmd"
    RBUFFER=""
  fi
  zle reset-prompt
}

zle -N fzf-command-widget
bindkey '^F' fzf-command-widget

fzf-tab-command-widget() {
  if [[ "$LBUFFER" == *[[:space:]]* ]]; then
    zle fzf-completion
  else
    local cmd=$(print -rl -- ${(k)commands} ${(k)aliases} | sort -u | fzf \
      --height=40% --layout=reverse --margin=1 --prompt="" \
      --query="$LBUFFER")
    if [[ -n "$cmd" ]]; then
      LBUFFER="$cmd"
      RBUFFER=""
    fi
    zle reset-prompt
  fi
}

zle -N fzf-tab-command-widget
bindkey '^I' fzf-tab-command-widget
