local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

bind(modKey "B", "omarchy-launch-browser", "Browser")
bind(modKey "SHIFT + B", "omarchy-launch-browser --private", "Browser (private)")
bind(modKey "M", "omarchy-launch-or-focus-class Spotify spotify", "Music")
bind(modKey "Z", "omarchy-launch-or-focus-class zen zen-browser", "Zen")
bind(modKey "N", "omarchy-launch-tui nvim", "Neovim")
bind(modKey "SHIFT + N", "omarchy-launch-tui nvim config", "Neovim Config")
bind(modKey "D", "vesktop --toggle", "Discord")
bind(modKey "SHIFT + S", "omarchy-launch-or-focus stremio", "Stremio")
bind("XF86Calculator", "omacalc", "Calculator")

-- Bindings similar to windows
bind("CTRL + SHIFT + ESCAPE", "omarchy-launch-tui btop", "Activity")

-- File manager shortcuts
-- Nautilus is the file manager, will change this soon
local file_manager = "nautilus"
local file_manager_cwd = file_manager .. ' "$(terminal-cwd)"'
bind(modKey "E", file_manager_cwd, "File manager (cwd)")
bind(modKey "CTRL + J", file_manager .. " ~/Downloads/", "Open downloads")
bind(modKey "SHIFT + F", file_manager, "File manager")

-- A running Ghostty in single-instance mode ignores --working-directory and
-- reuses its own cwd, so ask it for a new window over IPC instead.
local terminal_cwd = [[omarchy-launch-terminal --dir="$(terminal-cwd)"]]
bind(modKey "RETURN", terminal_cwd, "Terminal")

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

-- Just back to TMUX/herdr session
bind(modKey "ALT + RETURN", terminal_cwd .. [[ -e bash -c "tmux new-session -A -s main"]], "Tmux")
bind(modKey "CTRL + RETURN", terminal_cwd .. [[ -e bash -c "herdr"]], "Herdr")
