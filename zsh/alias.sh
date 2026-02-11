# Overwriting some behaviours for default alias
if command -v eza &> /dev/null; then
  alias ls="eza --group-directories-first --icons=auto --no-quotes"
  alias lsa="ls -a"
  alias lt="eza --tree --level=2 --icons --no-quotes"
  alias lta="lt -a"
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

common_config="--height 40% --layout reverse --tmux"
alias nvimff="ff --bind 'enter:become(nvim {-1})' $common_config "
alias gcb="git branch | fzf $common_config --preview 'git show --color=always {-1}' --bind 'enter:become(git checkout {-1})'"
alias cheat="curl cheat.sh/:list | fzf $common_config --bind 'enter:become(curl cheat.sh/{-1} | less)'"

alias mux="tmuxinator"
alias eixt="exit"
alias exp="nautilus"
alias obd="xdg-open obsidian://daily"
alias gip="gitInitPush"
alias timer="~/.config/waybar/scripts/timer.sh"
alias pomo="~/.config/waybar/scripts/timer.sh pomo"
alias pushpull="git push && pull 20"
alias push="git push"
alias a="asciinema"
alias rick-roll="curl ascii.live/rick"
alias hack="rick-roll"
alias start-hacking="rick-roll"

## Open file directly in it's editor super super handy (but gives error in bash)
if [ -n "$ZSH_VERSION" ]; then
    alias -s lua=nvim
    alias -s js=nvim
    alias -s ts=nvim
    alias -s mjs=nvim
    alias -s tsx=nvim
    alias -s json=nvim
    alias -s toml=nvim
    alias -s md=nvim
    alias -s html=nvim
    alias -s conf=nvim
    alias -s mp4=mpv
fi

# Sometimes I might run neovim commands
alias :q="exit"
alias :e="nvim"

src (){
  local file=${1:-~/.zshrc}
  if [[ -f $file ]]; then
    source "$file"
  fi
}

function gitInitPush() {
  REPO_NAME=${1:-$(basename "$(pwd)")}
  if [ ! -d ".git" ]; then
    git init
  fi
  git add .
  git commit -m "Initial commit"
  gh repo create "$REPO_NAME" --push --source . "${@:2}"
}

# Useful when just after pushing formatting is runing in gh actions
pull () {
  local count=${1:-1}
  for i in $(seq 1 "$count"); do
    output=$(git -c color.ui=always pull 2>&1)
    echo "$output"
    if [[ ! "$output" == *"up to date."* ]]; then
      break
    fi
    if [ "$i" -lt "$count" ]; then
      sleep 1  # Not sleeping in last iteration
    fi
  done
}

clone() {
  local url="$1"
  shift
  url="${url#/}"
  url="${url%/}"

  if [[ "$url" =~ ^https?:// ]]; then
    git clone "$url" "$@"
  elif [[ "$url" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9._-]+$ ]]; then
    git clone "https://github.com/$url" "$@"
  elif [[ "$url" =~ / ]]; then
    git clone "https://$url" "$@"
  else
    git clone "https://github.com/bibekbhusal0/$url" "$@"
  fi
}

gce () {
  emojified_text=$(devmoji --text "$1" | sed 's/"/\\"/g')
  git commit -am "$emojified_text"
}
