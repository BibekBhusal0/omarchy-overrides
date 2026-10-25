#!/bin/bash

set -euo pipefail

# omarchy update runs `pacman -Syu`, which skips IgnorePkg entries, but
# `omarchy refresh pacman` rewrites /etc/pacman.conf from a template, so the
# hold must also be re-applied by a pre-refresh-pacman hook.
HOOK_DIR="$HOME/.config/omarchy/hooks/pre-refresh-pacman.d"
HOOK="$HOOK_DIR/ignore-spotify"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/write-to-file.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"
source "$SCRIPT_DIR/../utils/clone.sh"
write_to_file "$HOOK" "$(cat <<'EOF'
#!/bin/bash

CONF=/etc/pacman.conf
LINE="IgnorePkg = spotify"

grep -qxF "$LINE" "$CONF" && exit 0
sudo sed -i "/^\[options\]/a $LINE" "$CONF"
EOF
)" true
chmod +x "$HOOK"

if ! grep -qxF 'IgnorePkg = spotify' /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a IgnorePkg = spotify' /etc/pacman.conf
fi

omarchy-pkg-aur-add spicetify-cli

clone BibekBhusal0/spicetify-extensions "$HOME/Code/spicetify-extensions"

if [[ -d /opt/spotify ]]; then
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr -R /opt/spotify/Apps
fi

mkdir -p "$HOME/.config/spicetify/Extensions"
create_symlink "$HOME/Code/spicetify-extensions/Omarchy" "$HOME/.config/spicetify/Themes/Omarchy"
create_symlink "$HOME/Code/spicetify-extensions/Omarchy/theme-hook.sh" "$HOME/.config/omarchy/hooks/theme-set.d/spicetify.sh"
spicetify config current_theme Omarchy color_scheme omarchy
"$HOME/.config/omarchy/hooks/theme-set.d/spicetify.sh"

curl -fsSL https://raw.githubusercontent.com/rxri/spicetify-extensions/main/adblock/adblock.js -o "$HOME/.config/spicetify/Extensions/adblock.js"
create_symlink "$HOME/Code/spicetify-extensions/keymap/keymap.js" "$HOME/.config/spicetify/Extensions/keymap.js"
create_symlink "$HOME/Code/spicetify-extensions/spicy-lyrics/dist/spicy-lyrics.js" "$HOME/.config/spicetify/Extensions/spicy-lyrics.js"
EXTENSIONS=(adblock.js keymap.js spicy-lyrics.js)

enabled=$(spicetify config extensions | tr '\n' ' ')
for ext in "${EXTENSIONS[@]}"; do
  case "|$enabled|" in *"|$ext|"*) ;; *) spicetify config extensions "$ext" ;; esac
done

create_symlink "$SCRIPT_DIR/../files_to_copy/spotify-flags.conf" "$HOME/.config/spotify-flags.conf"

if [[ ! -f "$HOME/.config/spotify/prefs" ]]; then
  echo "Theme colors are initialized. Open Spotify, log in, wait about 60 seconds, then rerun this installer to apply the theme."
  exit 0
fi

if ! grep -q '^\[Backup\]' "$(spicetify -c)"; then
  spicetify backup
fi

spicetify apply
"$HOME/.config/omarchy/hooks/theme-set.d/spicetify.sh"

echo "Theme: $(spicetify config current_theme 2>/dev/null)/$(spicetify config color_scheme 2>/dev/null)"
