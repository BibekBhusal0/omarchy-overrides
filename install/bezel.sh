#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Pinned release. Change the version and checksum together, after reviewing the
# release, so a re-run cannot silently pick up different code.
BEZEL_VERSION="v1.1.0"
BEZEL_ASSET="bezel-x86_64-unknown-linux-gnu"
BEZEL_SHA256="5b21ef91011fc1c2de9beab1b8f5bc03ecfc2e3e5a494470387dad44738fd5fc"

BEZEL_BIN="$HOME/.local/bin/bezel"
CONFIG_SRC="$REPO_ROOT/files_to_copy/bezel.toml"
CONFIG_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/bezel/config.toml"
UDEV_SRC="$REPO_ROOT/files_to_copy/udev/99-bezel.rules"
UDEV_DEST="/etc/udev/rules.d/99-bezel.rules"

source "$REPO_ROOT/utils/symlink.sh"

uninstall() {
  pkill -x bezel 2>/dev/null || true
  rm -f "$BEZEL_BIN"
  if [ -L "$CONFIG_DEST" ]; then
    rm -f "$CONFIG_DEST"
  fi
  if [ -f "$UDEV_DEST" ]; then
    sudo rm -f "$UDEV_DEST"
    sudo udevadm control --reload-rules
  fi
  echo "Bezel removed. Group membership and config backups were left alone."
}

if [ "${1:-}" = "--uninstall" ]; then
  uninstall
  exit 0
fi

if [ "$(uname -m)" != "x86_64" ]; then
  echo "Unsupported architecture: $(uname -m)" >&2
  exit 1
fi

for cmd in curl sha256sum udevadm; do
  command -v "$cmd" >/dev/null || {
    echo "Missing command: $cmd" >&2
    exit 1
  }
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading Bezel $BEZEL_VERSION..."
curl -fsSL -o "$tmp/bezel" \
  "https://github.com/Indra55/bezel/releases/download/$BEZEL_VERSION/$BEZEL_ASSET"
echo "$BEZEL_SHA256  $tmp/bezel" | sha256sum -c -

install -Dm755 "$tmp/bezel" "$BEZEL_BIN"

echo "Installing uinput udev rule..."
sudo install -m644 "$UDEV_SRC" "$UDEV_DEST"
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=misc --sysname-match=uinput

needs_relogin=0
if ! id -nG "$USER" | tr ' ' '\n' | grep -qx input; then
  echo "Adding $USER to the input group..."
  sudo usermod -aG input "$USER"
  needs_relogin=1
fi

create_symlink "$CONFIG_SRC" "$CONFIG_DEST"
"$BEZEL_BIN" --config "$CONFIG_DEST" --check-config

if [ "$needs_relogin" -eq 1 ]; then
  echo "Reboot to apply the input group membership. Bezel starts with Hyprland."
else
  echo "Run 'bezel' now to try it, or restart Hyprland. It autostarts on the next session."
fi
