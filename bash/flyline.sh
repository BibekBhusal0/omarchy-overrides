[[ $- == *i* ]] || return 0
enable flyline 2>/dev/null || enable -f /usr/lib/libflyline.so flyline
flyline --load-zsh-history
flyline --show-animations false
flyline --send-shell-integration-codes full
flyline set-style --default-theme dark
flyline set-cursor --backend terminal
flyline mouse --mode smart --change-shape
flyline editor --show-inline-history true --select-with-mouse --auto-close-chars
flyline editor --show-inline-history-metadata false
flyline suggestions --auto-suggest true --use-flycomp --git-ref-mtime --sort-order mtime --num-suggestion-rows 12
flyline suggestions set-fuzzy-mode all
flyline key bind Ctrl+r 'always=runBashCommand(__fzf_history__)'
flyline key bind Ctrl+t 'always=runBashCommand(fzf-file-widget)'
if command -v fzf >/dev/null 2>&1; then
  flyline_fzf_completion() {
    local point=${READLINE_POINT:-${#READLINE_LINE}}
    local line=${READLINE_LINE:0:point}
    local trigger=${FZF_COMPLETION_TRIGGER-'**'}
    local completion_function current_word previous_word word_start selected escaped
    local COMP_CWORD COMP_LINE COMP_POINT COMP_TYPE COMP_KEY
    local -a COMP_WORDS COMPREPLY

    read -r -a COMP_WORDS <<< "$line"
    COMP_CWORD=$((${#COMP_WORDS[@]} - 1))
    (( COMP_CWORD >= 0 )) || return
    current_word=${COMP_WORDS[COMP_CWORD]}
    [[ $current_word == *"$trigger" ]] || return

    if [[ ${COMP_WORDS[0]} == -* ]]; then
      completion_function=__fzf_default_completion
    else
      completion_function=$(complete -p -- "${COMP_WORDS[0]}" 2>/dev/null)
      if [[ $completion_function =~ -F[[:space:]]+([^[:space:]]+) && ${BASH_REMATCH[1]} == _fzf_* ]]; then
        completion_function=${BASH_REMATCH[1]}
      else
        completion_function=__fzf_default_completion
      fi
    fi

    COMP_LINE=$line
    COMP_POINT=$point
    COMP_TYPE=9
    COMP_KEY=9
    previous_word=
    if (( COMP_CWORD > 0 )); then
      previous_word=${COMP_WORDS[COMP_CWORD-1]}
    fi
    COMPREPLY=()
    "$completion_function" "$current_word" "$previous_word" "${COMP_WORDS[*]}" "$COMP_CWORD"
    [[ -n ${COMPREPLY[0]:-} ]] || return

    word_start=$((point - ${#current_word}))
    selected=${COMPREPLY[0]}
    printf -v escaped '%q' "$selected"
    READLINE_LINE="${READLINE_LINE:0:word_start}${escaped}${READLINE_LINE:point}"
    READLINE_POINT=$((word_start + ${#escaped}))
  }

  flyline key bind Tab 'always=runBashCommand(flyline_fzf_completion)'
fi
flyline key bind Ctrl+n tabCompletionAvailable=tabCompletionNextSuggestion
flyline key bind Ctrl+p tabCompletionAvailable=tabCompletionPrevSuggestion
flyline key bind Ctrl+y tabCompletionAvailable=tabCompletionNextSuggestion+tabCompletionAcceptEntry
flyline key bind Ctrl+y tabCompletionEntrySelected=tabCompletionAcceptEntry
flyline key bind Alt+l inlineSuggestionAvailable=inlineSuggestionAccept

flyline set-agent-mode \
  --system-prompt "Be concise. Answer with a JSON array of at most 3 items with objects containing: command and description. Command will be a Bash command. Every command must be complete and immediately runnable with concrete arguments only. Strictly forbidden: placeholders such as <filename>, [path], {dir}, \$VAR, TODO, etc. Never output angle brackets or square-bracket placeholders." \
  --trigger-prefix ': ' \
  --command 'opencode run --agent plan'
