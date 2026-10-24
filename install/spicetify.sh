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

if [[ -d /opt/spotify ]]; then
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr -R /opt/spotify/Apps
fi

if [[ ! -f "$HOME/.config/spotify/prefs" ]]; then
  echo "Open Spotify, log in, wait ~60s, then run: spicetify backup apply"
  exit 0
fi

# Omarchy theme refresh happens via the theme-set hook; only the CSS lives here.
create_symlink "$SCRIPT_DIR/../files_to_copy/spicetify-theme-hook.sh" "$HOME/.config/omarchy/hooks/theme-set.d/spicetify.sh"
create_symlink "$SCRIPT_DIR/../files_to_copy/spicetify-theme.css" "$HOME/.config/spicetify/Themes/Omarchy/user.css"
spicetify config current_theme Omarchy color_scheme omarchy

# Keybinds extension lives in its own repo, cloned like the other personal repos.
clone BibekBhusal0/spicetify-keys "$HOME/Code/spicetify-keys"
ln -sfn "$HOME/Code/spicetify-keys/omarchy-keys.js" "$HOME/.config/spicetify/Extensions/omarchy-keys.js"

curl -fsSL https://raw.githubusercontent.com/rxri/spicetify-extensions/main/adblock/adblock.js -o "$HOME/.config/spicetify/Extensions/adblock.js"
create_symlink "$SCRIPT_DIR/../files_to_copy/spicetify-keys.js" "$HOME/.config/spicetify/Extensions/omarchy-keys.js"
EXTENSIONS=(adblock.js fullAppDisplay.js omarchy-keys.js)

enabled=$(spicetify config extensions | tr '\n' ' ')
for ext in "${EXTENSIONS[@]}"; do
  case "|$enabled|" in *"|$ext|"*) ;; *) spicetify config extensions "$ext" ;; esac
done

if ! grep -q '^\[Backup\]' "$(spicetify -c)"; then
  spicetify backup
fi

# The client reads ~/.config/spotify-flags.conf at every launch; the debug port
# is what the theme hook reloads the UI over.
create_symlink "$SCRIPT_DIR/../files_to_copy/spotify-flags.conf" "$HOME/.config/spotify-flags.conf"

spicetify apply
"$HOME/.config/omarchy/hooks/theme-set.d/spicetify.sh"

echo "Theme: $(spicetify config current_theme 2>/dev/null)/$(spicetify config color_scheme 2>/dev/null)"
