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
flyline key bind Ctrl+n tabCompletionAvailable=tabCompletionNextSuggestion
flyline key bind Ctrl+p tabCompletionAvailable=tabCompletionPrevSuggestion
flyline key bind Ctrl+y tabCompletionAvailable=tabCompletionAcceptEntry
flyline key bind Alt+l inlineSuggestionAvailable=inlineSuggestionAccept

flyline set-agent-mode \
  --system-prompt "Be concise. Answer with a JSON array of at most 3 items with objects containing: command and description. Command will be a Bash command. Every command must be complete and immediately runnable with concrete arguments only. Strictly forbidden: placeholders such as <filename>, [path], {dir}, \$VAR, TODO, etc. Never output angle brackets or square-bracket placeholders." \
  --trigger-prefix ': ' \
  --command 'opencode run --agent plan'
