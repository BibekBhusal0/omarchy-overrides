SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/clone.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"
source "$SCRIPT_DIR/../utils/write-to-file.sh"

clone omarchy-shell-plugins ~/Code/omarchy-shell-plugins/
mkdir -p ~/.config/omarchy/plugins

install_my_plugin() {
  local name="$1"
  create_symlink ~/Code/omarchy-shell-plugins/$name "$HOME/.config/omarchy/plugins/$name"
  create_symlink ~/Code/omarchy-shell-plugins/$name/config.json "$HOME/.config/omarchy/$name.json"
}

install_my_plugin media
install_my_plugin focusd
install_my_plugin ytdl
install_my_plugin obsidian-search
install_my_plugin readest
install_my_plugin lock
install_my_plugin menu

EXTERNAL_DIR="$HOME/Code/other-omarchy-plugins"
mkdir -p "$EXTERNAL_DIR"

install_external_plugin() {
  local repo="$1"
  local subdir="${2:-}"
  local name="${repo##*/}"
  clone "$repo" "$EXTERNAL_DIR/$name" --depth=1
  local src="$EXTERNAL_DIR/$name"
  [[ -n "$subdir" ]] && src="$src/$subdir"
  create_symlink "$src" "$HOME/.config/omarchy/plugins/$name"
}

install_external_plugin ESHAYAT102/confetti-omarchy-plugin
install_external_plugin janhesters/omarchy-focus
install_external_plugin idr4n/omarchy-clipboard-plus
create_symlink ~/.config/omarchy/plugins/omarchy-focus/focus ~/.local/bin/focus

write_to_file "$HOME/.config/omarchy/focus-sites" "youtube.com
www.youtube.com
reddit.com
www.reddit.com"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
create_symlink "$SCRIPT_DIR/../files_to_copy/shell.json" "$HOME/.config/omarchy/shell.json"
omarchy-restart-shell
