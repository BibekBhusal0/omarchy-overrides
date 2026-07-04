_minimal_highlight() {
  emulate -L zsh

  local line=${BUFFER%%$'\n'*}
  local cmd=${line%%[[:space:]]*}

  region_highlight=( ${region_highlight:#*memo=minimal-highlight*} )

  if [[ -n $cmd ]]; then
    if (( $+commands[$cmd] )) || (( $+aliases[$cmd] )) || (( $+functions[$cmd] )); then
      region_highlight+=( "0 ${#cmd} fg=green,memo=minimal-highlight" )
    else
      region_highlight+=( "0 ${#cmd} fg=red,memo=minimal-highlight" )
    fi
  fi
}

function zle-line-pre-redraw {
  _minimal_highlight
}

zle -N zle-line-pre-redraw
