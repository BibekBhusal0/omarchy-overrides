# Overwriting some behaviours for default alias
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto --oneline'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --icons --git'
  alias lta='lt -a'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias nvimff='nvim $(ff)'
alias gcb='git branch | fzf --preview "git show --color=always {-1}" |
             cut -c 3- | xargs git checkout'
alias eixt='exit'
alias exp='nautilus'
alias obd='xdg-open obsidian://daily'
alias gip='gitInitPush'
alias timer='~/.config/waybar/scripts/timer.sh'
alias pomo='~/.config/waybar/scripts/timer.sh pomo'
alias pushpull='git push && pull 20'
alias a='asciinema'

# Sometimes I might run neovim commands
alias :q='exit'
alias :e='nvim'

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

git config --global alias.a 'add'
git config --global alias.ps 'push'
git config --global alias.pl 'pull'
git config --global alias.c 'commit -m'
git config --global alias.s 'status'
git config --global alias.co 'checkout'
git config --global alias.b 'branch'
git config --global alias.l "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short"
