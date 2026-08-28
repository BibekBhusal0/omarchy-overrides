source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/symlink.sh"

clone omarchy-shell-plugins ~/Code/omarchy-shell-plugins/
mkdir -p ~/.config/omarchy/plugins

install_my_plugin() {
  local name="$1"
  rm -rf ~/.config/omarchy/plugins/$name
  cp -r ~/Code/omarchy-shell-plugins/$name ~/.config/omarchy/plugins/$name
}

install_my_plugin media
install_my_plugin focusd
install_my_plugin ytdl
install_my_plugin obsidian-search
install_my_plugin readest
install_my_plugin lock

clone Praveensenpai/omarchy-refined-menu ~/Code/random/omarchy-refined-menu --depth=1
clone younesdahdouh/omarchy-super-apps ~/.config/omarchy/plugins/apps-luncher --depth=1
clone ESHAYAT102/confetti-omarchy-plugin ~/.config/omarchy/plugins/confetti  --depth=1
create_symlink ~/Code/random/omarchy-refined-menu/plugin ~/.config/omarchy/plugins/menu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
create_symlink "$SCRIPT_DIR/../files_to_copy/shell.json" "$HOME/.config/omarchy/shell.json"
omarchy-restart-shell
