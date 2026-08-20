source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/symlink.sh"

clone omarchy-shell-plugin ~/Code/omarchy-shell-plugin/
mkdir -p ~/.config/omarchy/plugins

install_my_plugin() {
  local name="$1"
  rm -rf ~/.config/omarchy/plugins/$name
  cp -r ~/Code/omarchy-shell-plugin/$name ~/.config/omarchy/plugins/$name
}

install_my_plugin media
install_my_plugin focusd
install_my_plugin ytdl
install_my_plugin obsidian-search
install_my_plugin readest

clone markbus-ai/omarchy-opencode-usage ~/.config/omarchy/plugins/opencode --depth=1
clone Praveensenpai/omarchy-refined-menu ~/Code/random/omarchy-refined-menu --depth=1
create_symlink ~/Code/random/omarchy-refined-menu/plugin ~/.config/omarchy/plugins/menu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
create_symlink "$SCRIPT_DIR/../files_to_copy/shell.json" "$HOME/.config/omarchy/shell.json"
omarchy-restart-shell
