local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

-- Bindings similar to windows
bind("CTRL + SHIFT + ESCAPE", "omarchy-launch-tui btop", "Activity")

-- File manager shortcuts
-- Nautilus is the file manager, will change this soon
local file_manager = "nautilus"
local file_manager_cwd = file_manager .. ' "$(terminal-cwd)"'
bind(modKey "E", file_manager_cwd, "File manager (cwd)")
bind(modKey "CTRL + J", file_manager .. " ~/Downloads/", "File manager (downloads directory)")
bind(modKey "SHIFT + F", file_manager, "File manager")
bind(modKey "ALT + SHIFT + F", file_manager_cwd, "File manager (cwd)")

-- A running Ghostty in single-instance mode ignores --working-directory and
-- reuses its own cwd, so ask it for a new window over IPC instead.
local terminal_cwd = [[uwsm-app -- ghostty +new-window --working-directory="$(terminal-cwd)"]]
bind(modKey "RETURN", terminal_cwd, "Terminal")

-- Ruler to measure screen
bind(modKey "SHIFT + R", "hypruler", "Ruler")

-- Time
bind(modKey "CTRL + T", "omarchy-notification-time", "Show time")

-- T3 Code
local t3_launch =
  "omarchy-launch-or-focus-class com.t3tools.T3Code /home/bibek/.local/share/t3code/T3-Code.AppImage"
bind(modKey "SHIFT + T", t3_launch, "T3 Code")
-- Copilot key
bind("SUPER + SHIFT + code:201", t3_launch, "T3 Code")
-- Global shortcut for screenshot (needs to configure settings in t3 code)
local t3_capture = hl.dsp.global "com.t3tools.T3Code:capture-window"
bind(modKey "SHIFT + CTRL + Print", t3_capture, "T3 Code snap shot")

-- Launch all apps i use
bind(modKey "SLASH", "start", "Launch All Apps I Use")
bind(modKey "SHIFT + SLASH", "uwsm-app -- bitwarden.desktop", "Passwords")

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

-- Just back to TMUX session
bind(
  modKey "ALT + RETURN",
  [[uwsm-app -- ghostty +new-window -e bash -c "tmux new-session -A -s main"]],
  "Tmux"
)

-- Lunching apps
bind(modKey "B", "omarchy-launch-browser", "Browser")
bind(modKey "SHIFT + B", "omarchy-launch-browser --private", "Browser (private)")
bind(modKey "M", "omarchy-launch-or-focus-class Spotify spotify", "Music")
bind(modKey "Z", "omarchy-launch-or-focus-class zen zen-browser", "Zen")
bind(modKey "N", "omarchy-launch-tui nvim", "Neovim")
bind(modKey "SHIFT + N", "omarchy-launch-tui nvim config", "Neovim Config")
bind(modKey "D", "vesktop --toggle", "Discord")
bind(modKey "SHIFT + S", "omarchy-launch-or-focus stremio", "Stremio")

-- Obsidian
local function openObsidian(vault)
  return 'uwsm-app -- obsidian -disable-gpu --enable-wayland-ime "obsidian://open?vault='
    .. vault
    .. '"'
end
local obSearchYoutube =
  'omarchy-shell shell toggle bibek.obsidian-search \'{"vaultPath":"~/Youtube/Youtube"}\''
-- :TODO: Migrate to obsidian CLI
bind(modKey "SHIFT + O", 'obsidian "obsidian://daily?vault=vault"', "Obsidian Daily")
bind(modKey "O", openObsidian "vault", "Obsidian (main vault)")
bind(modKey "Y", openObsidian "Youtube", "Obsidian (Youtube vault)")
bind(modKey "ALT + O", "omarchy-shell shell toggle bibek.obsidian-search", "Obsidian Search")
bind(modKey "ALT + Y", obSearchYoutube, "Obsidian Search (Youtube vault)")
bind(modKey "ALT + D", "omarchy-shell shell toggle bibek.obsidian-daily", "Obsidian Daily (tasks)")

-- Next/Prev media for laptop with no next/prev buttons
bind(modKey "bracketleft", "omarchy-shell media previous", "Previous Media")
bind(modKey "bracketright", "omarchy-shell media next", "Next Media")

-- Fastest way to suspedn
bind(modKey "SHIFT + ESCAPE", "systemctl suspend", "Suspend")

-- My custom web apps
bind(modKey "A", 'omarchy-launch-webapp "https://chatgpt.com"', "ChatGPT")
bind(modKey "SHIFT + C", 'omarchy-launch-webapp "https://chess.com"', "Chess.com")
bind(modKey "SHIFT + M", 'omarchy-launch-webapp "https://pocketcasts.com/podcasts"', "PocketCasts")
bind(modKey "SHIFT + G", 'omarchy-launch-webapp "https://github.com/"', "Github")
bind(modKey "R", 'omarchy-launch-webapp "https://reddit.com/"', "Reddit")
bind(modKey "SHIFT + D", 'omarchy-launch-webapp "https://duck.ai/"', "Duck.ai")

-- Pomodoro (focusd)
bind(modKey "P", "focusd toggle", "Pomodoro toggle")
bind(modKey "SHIFT + P", hl.dsp.window.pseudo(), "Pseudo window")

-- 4.5 binds Alt + Space to dictation, which eats the tmux and herdr prefix.
hl.unbind "ALT + SPACE"

-- Right alt is my compose so this dictatioin keymap was also not applied
hl.unbind "ALT + ALT_R"

-- Some usable keymaps for dictation
if
  o.dictation_installed
  and type(o.dictation_installed) == "function"
  and o.dictation_installed()
then
  -- I use Super + W to close app so this can be safely overwritten
  bind(modKey "Q", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold(
    "CTRL + SPACE",
    "Start dictation (push-to-talk)",
    "omarchy-dictation start",
    "Stop dictation (push-to-talk)",
    "omarchy-dictation stop"
  )
end

-- 4.5 moved some keymaps; I prefer the old ones
bind(modKey "CTRL + W", "omarchy-shell shell toggle omarchy.network", "Network")
bind(modKey "CTRL + N", "omarchy-toggle-nightlight", "Toggle nightlight")
