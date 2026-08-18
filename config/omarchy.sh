omarchy-plugin-disable omarchy.menu # This only disables one on bar
omarchy-plugin-disable omarchy.weather
omarchy-plugin-disable omarchy.media
omarchy-plugin-disable omarchy.agents
omarchy-plugin-disable omarchy.nightlight
omarchy-plugin-disable omarchy.dev-gallery
omarchy-plugin-enable omarchy.tailscale

source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"

# Adding my own plugins
clone omarchy-shell-plugin ~/Code/omarchy-shell-plugin/
mkdir -p ~/.config/omarchy/plugins
rm -rf ~/.config/omarchy/plugins/focusd ~/.config/omarchy/plugins/obsidian-search ~/.config/omarchy/plugins/readest ~/.config/omarchy/plugins/media
cp -r ~/Code/omarchy-shell-plugin/focusd ~/.config/omarchy/plugins/focusd
cp -r ~/Code/omarchy-shell-plugin/obsidian-search ~/.config/omarchy/plugins/obsidian-search
cp -r ~/Code/omarchy-shell-plugin/readest ~/.config/omarchy/plugins/readest
cp -r ~/Code/omarchy-shell-plugin/media ~/.config/omarchy/plugins/media
omarchy plugin validate ~/.config/omarchy/plugins/focusd
omarchy plugin validate ~/.config/omarchy/plugins/obsidian-search
omarchy plugin validate ~/.config/omarchy/plugins/readest
omarchy plugin validate ~/.config/omarchy/plugins/media
omarchy-shell shell rescanPlugins
omarchy plugin enable bibek.focusd --section left
omarchy plugin enable bibek.obsidian-search
omarchy plugin enable bibek.readest
omarchy plugin enable bibek.media --section left

omarchy-restart-shell
