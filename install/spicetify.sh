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

curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

THEME_DIR="$HOME/.config/spicetify/Themes/Ziro"
if [[ ! -f "$THEME_DIR/color.ini" || ! -f "$THEME_DIR/user.css" ]]; then
  mkdir -p "$THEME_DIR"
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Ziro/color.ini -o "$THEME_DIR/color.ini"
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Ziro/user.css -o "$THEME_DIR/user.css"
fi
spicetify config current_theme Ziro color_scheme green-dark

EXT_FILE="$HOME/.config/spicetify/Extensions/adblock.js"
if [[ ! -f "$EXT_FILE" ]]; then
  curl -fsSL https://raw.githubusercontent.com/rxri/spicetify-extensions/main/adblock/adblock.js -o "$EXT_FILE"
fi
EXTENSIONS=(shuffle+.js keyboardShortcut.js adblock.js)

enabled=$(spicetify config extensions | tr '\n' ' ')
for ext in "${EXTENSIONS[@]}"; do
  case "|$enabled|" in *"|$ext|"*) ;; *) spicetify config extensions "$ext" ;; esac
done

if ! grep -q '^\[Backup\]' "$(spicetify -c)"; then
  spicetify backup
fi
spicetify apply

echo "Theme: $(spicetify config current_theme)/$(spicetify config color_scheme)"
echo "Extensions: $(spicetify config extensions | tr '\n' ' ')"
