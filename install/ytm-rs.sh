#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

# Dependencies required by ytm-rs on Arch Linux
omarchy-pkg-install webkit2gtk-4.1 gtk3 libayatana-appindicator alsa-lib desktop-file-utils

REPO="grapedjuice/ytm-rs"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
LIB_DIR="$HOME/.local/lib/ytm-rs"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$DATA_DIR/applications"
ICON_DIR="$DATA_DIR/icons/hicolor/256x256/apps"

ARCH="$(uname -m)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Fetching latest release for ytm-rs ($ARCH)..."
RELEASE_URL="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | \
  grep -o "https://[^\"]*/ytm-rs-[0-9][^\"/]*-linux-$ARCH\.tar\.gz" | head -n 1)"

if [[ -z "$RELEASE_URL" ]]; then
  echo "Error: No release found for architecture $ARCH." >&2
  exit 1
fi

curl -fL# "$RELEASE_URL" | tar -xz -C "$TMP_DIR"
EXTRACTED_DIR="$(dirname "$(find "$TMP_DIR" -name ytm-rs -type f | head -n 1)")"

mkdir -p "$LIB_DIR" "$BIN_DIR" "$DESKTOP_DIR" "$ICON_DIR"

# Install binary atomically
cp "$EXTRACTED_DIR/ytm-rs" "$LIB_DIR/ytm-rs.new"
chmod 755 "$LIB_DIR/ytm-rs.new"
mv -f "$LIB_DIR/ytm-rs.new" "$LIB_DIR/ytm-rs"

# Install desktop entry and icon
sed "s|^Exec=ytm-rs|Exec=$LIB_DIR/ytm-rs|" "$EXTRACTED_DIR/ytm-rs.desktop" > "$DESKTOP_DIR/ytm-rs.desktop"
cp "$EXTRACTED_DIR/ytm-rs.png" "$ICON_DIR/ytm-rs.png"

# Symlink CLI executable
create_symlink "$LIB_DIR/ytm-rs" "$BIN_DIR/ytm-rs"

# Update desktop & icon caches
update-desktop-database -q "$DESKTOP_DIR" 2>/dev/null || true
gtk-update-icon-cache -q -t "$DATA_DIR/icons/hicolor" 2>/dev/null || true

echo "ytm-rs successfully installed to $LIB_DIR/ytm-rs."
