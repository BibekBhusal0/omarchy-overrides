local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

-- Summoning Shell
local confetti = "omarchy-shell shell summon io.github.weedwhitesandwine.omafetti"
local clipboard = "omarchy-shell shell toggle io.github.idr4n.clipboard-plus"
bind(modKey "ALT + R", "omarchy-shell shell toggle bibek.readest", "Readest search")
bind(modKey "ALT + M", "omarchy-shell shell toggle bibek.media", "Media Menu")
bind(modKey "CTRL + Y", "omarchy-shell shell toggle bibek.ytdl", "Download youtube videos")
bind(modKey "ALT + P", "omarchy-shell shell toggle bibek.focusd", "Pomodoro popup")
bind(modKey "SHIFT + E", confetti, "Confetti  🎉")
bind(modKey "CTRL + SHIFT + E", "omarchy-shell shell toggle omarchy.elsewhen", "World clock")
bind(modKey "SUPER_L", 'omarchy-shell shell toggle bibek.menu \'{"menu":"apps"}\'', "Apps")
bind(modKey "ALT + SPACE", 'omarchy-shell shell toggle bibek.menu \'{"menu":"apps"}\'', "Apps")
bind(modKey "CTRL + V", clipboard, "Clipboard History")

-- Next/Prev media for laptop with no next/prev buttons
bind(modKey "bracketleft", "omarchy-shell media previous", "Previous Media")
bind(modKey "bracketright", "omarchy-shell media next", "Next Media")

-- 4.5 moved some keymaps; I prefer the old ones
bind(modKey "CTRL + W", "omarchy-shell shell toggle omarchy.network", "Network")
bind(modKey "CTRL + N", "omarchy-toggle-nightlight", "Toggle nightlight")
