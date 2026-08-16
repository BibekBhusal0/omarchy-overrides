#!/bin/bash

set -euo pipefail

# omarchy update runs `pacman -Syu`, which skips IgnorePkg entries, but
# `omarchy refresh pacman` rewrites /etc/pacman.conf from a template, so the
# hold must also be re-applied by a pre-refresh-pacman hook.
HOOK_DIR="$HOME/.config/omarchy/hooks/pre-refresh-pacman.d"
HOOK="$HOOK_DIR/ignore-spotify"

mkdir -p "$HOOK_DIR"
cat > "$HOOK" <<'EOF'
#!/bin/bash

CONF=/etc/pacman.conf
LINE="IgnorePkg = spotify"

grep -qxF "$LINE" "$CONF" && exit 0
sudo sed -i "/^\[options\]/a $LINE" "$CONF"
EOF
chmod +x "$HOOK"

if ! grep -qxF 'IgnorePkg = spotify' /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a IgnorePkg = spotify' /etc/pacman.conf
fi

omarchy-pkg-aur-add spicetify-cli

if [[ -d /opt/spotify ]]; then
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr -R /opt/spotify/Apps
fi

if [[ ! -f "$HOME/.config/spotify/prefs" ]]; then
  echo "Open Spotify, log in, wait ~60s, then run: spicetify backup apply"
  exit 0
fi

spicetify backup apply
