SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/clone.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"
source "$SCRIPT_DIR/../utils/write-to-file.sh"

clone omarchy-shell-plugins ~/Code/omarchy-shell-plugins/
mkdir -p ~/.config/omarchy/plugins

install_my_plugin() {
  local name="$1"
  create_symlink ~/Code/omarchy-shell-plugins/$name "$HOME/.config/omarchy/plugins/$name"
  if [[ -f ~/Code/omarchy-shell-plugins/$name/config.json ]]; then
    rm -f "$HOME/.config/omarchy/$name.json"
    cp ~/Code/omarchy-shell-plugins/$name/config.json "$HOME/.config/omarchy/$name.json"
  fi
}

# obsidian-daily ships its Rust backend as source; the QML resolves
# omarchy/bin/obsidian-daily-qs-<arch>, so build it when missing or stale.
build_obsidian_daily() {
  local dir="$HOME/Code/omarchy-shell-plugins/obsidian-daily"
  local arch
  arch="$(uname -m)"
  if [[ "$arch" != x86_64 && "$arch" != aarch64 ]]; then
    return 0
  fi
  local out="$dir/omarchy/bin/obsidian-daily-qs-$arch"
  if [[ -x "$out" ]] && ! find "$dir/src" "$dir/Cargo.toml" "$dir/Cargo.lock" -newer "$out" -print -quit | grep -q .; then
    return 0
  fi
  if ! command -v cargo >/dev/null 2>&1; then
    echo "obsidian-daily: cargo not found, skipping backend build" >&2
    return 0
  fi
  (cd "$dir" && cargo build --release) || {
    echo "obsidian-daily: backend build failed" >&2
    return 0
  }
  install -Dm755 "$dir/target/release/obsidian-daily-qs" "$out"
}

install_my_plugin media
install_my_plugin focusd
install_my_plugin ytdl
install_my_plugin obsidian-search
install_my_plugin readest
install_my_plugin lock
install_my_plugin menu
install_my_plugin obsidian-daily
build_obsidian_daily

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
