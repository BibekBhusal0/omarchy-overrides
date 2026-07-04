_minimal_highlight() {
  emulate -L zsh

  region_highlight=( ${region_highlight:#*memo=minimal-highlight*} )

  local line=${BUFFER%%$'\n'*}
  local token
  local start
  local expect_command=1
  local search_from=1

  local -a words
  words=( ${(z)line} )

  for token in $words; do
    local rest=${line[search_from,-1]}
    local rel=${rest[(i)$token]}

    (( rel <= ${#rest} )) || continue

    start=$(( search_from + rel - 1 ))
    search_from=$(( start + ${#token} ))

    if (( expect_command )); then
      if (( $+commands[$token] )) || (( $+aliases[$token] )) || (( $+functions[$token] )); then
        region_highlight+=( "$((start - 1)) $((start - 1 + ${#token})) fg=green,memo=minimal-highlight" )
      else
        region_highlight+=( "$((start - 1)) $((start - 1 + ${#token})) fg=red,memo=minimal-highlight" )
      fi

      expect_command=0
    fi

    case $token in
      '|'|'||'|'&'|'&&'|';')
        expect_command=1
        ;;
    esac
  done
}

function zle-line-pre-redraw {
  _minimal_highlight
}

zle -N zle-line-pre-redraw
