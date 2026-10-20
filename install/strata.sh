#!/bin/bash

set -euo pipefail

BIN="$HOME/.local/bin/strata"
[ -x "$BIN" ] && exit 0

case "$(uname -m)" in
  x86_64) target="x86_64-unknown-linux-gnu" ;;
  aarch64) target="aarch64-unknown-linux-gnu" ;;
  *) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

omarchy-pkg-add \
  bubblewrap desktop-file-utils ffmpeg ffmpegthumbnailer fontconfig \
  gst-libav gstreamer gst-plugins-base gst-plugins-good \
  gtk4 gtksourceview5 gvfs poppler-glib xdg-utils

release="$(curl -fsSL https://api.github.com/repos/lgse/strata/releases/latest)"
url="$(jq -r --arg t "$target" '.assets[] | select(.name | endswith("-" + $t + ".tar.gz")) | .browser_download_url' <<<"$release")"
archive="$(basename "$url")"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSL -o "$archive" "$url"
tar -xzf "$archive"

dir="${archive%.tar.gz}"
install -Dm755 "$dir/strata" "$BIN"
install -Dm644 "$dir/io.github.lgse.Strata.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/io.github.lgse.Strata.svg"
sed "s|^Exec=strata |Exec=$BIN |" "$dir/io.github.lgse.Strata.desktop" \
  > "$HOME/.local/share/applications/io.github.lgse.Strata.desktop"
xdg-mime default io.github.lgse.Strata.desktop inode/directory
