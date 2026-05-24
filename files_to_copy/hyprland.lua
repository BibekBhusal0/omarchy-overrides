local exec = hl.dsp.exec_cmd

---Wrapper for setting keybinds
---@param key string  the key or the key combination
---@param cmd string|function  THe command to be executed when key is pressed
---@param description string  description of the keymap
local function bind(key, cmd, description)
	local command = cmd
	if type(cmd) == "string" then
		command = exec(cmd)
	end
	-- Unbind before binding new to avaoid conflicts.
	hl.unbind(key)
	hl.bind(key, command, { description = description })
end

local function modKey(keys)
	return ("SUPER + " .. keys)
end

-- Bindings similar to windows
bind(modKey("E"), "uwsm-app -- nautilus --new-window $(omarchy-cmd-terminal-cwd)", "File manager")
bind("CTRL + SHIFT + ESCAPE", "floating-terminal btop", "Activity")

-- Ruler to measure screen
bind(modKey("SHIFT + R"), "hypruler", "Ruler")

-- -- :NOTE: This Should be removed keeping it here just in case
-- -- Pomodoro timer
-- bind(
-- 	modKey("SHIFT + P"),
-- 	"bash -c '[[ $(timeout 0.05s ~/.config/waybar/scripts/timer.sh | head -n1 | jq -r \".class\") =~ (idle|disabled) ]] && ~/.config/waybar/scripts/timer.sh pomo || ~/.config/waybar/scripts/timer.sh toggle'",
-- 	"Pomodoro Timer"
-- )

-- Launch all apps i use
bind(modKey("SLASH"), "start", "Launch All Apps I Use")

-- Toggling the animation
local function toggle_animations()
	local enabled = hl.get_config("animations:enabled")
	hl.config({ animations = { enabled = not enabled } })
	local status = not enabled and "Enabled" or "Disabled"
	hl.exec_cmd(string.format("notify-send 'Animations %s'", status))
end
bind(modKey("ALT + A"), toggle_animations, "Toggle Animation")

-- Pop open window to fit in my screen
bind(modKey("P"), "omarchy-hyprland-window-pop 1300 700", "Pop window out")

-- -- :TODO: This might not be needed in new version should test before uncommenting.
-- -- Open things in floating terminal
-- bind(modKey("CTRL + A"), "floating-terminal wiremix", "Audio controls")
-- bind(modKey("CTRL + B"), "floating-terminal bluetui", "Bluetooth controls")
-- bind(modKey("CTRL + W"), "floating-terminal impala", "Wifi controls")

-- -- :NOTE: This Should be removed keeping it here just in case
-- bind(
-- 	modKey("SHIFT + RETURN"),
-- 	'env NO_TMUX=1 uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"',
-- 	"Terminal (no tmux)"
-- )

-- Lunching apps
bind(modKey("B"), "omarchy-launch-browser", "Browser")
bind(modKey("SHIFT + B"), "omarchy-launch-browser --private", "Browser (private)")
bind(modKey("Z"), "omarchy-launch-or-focus zen-browser", "Zen")
bind(modKey("N"), "omarchy-launch-tui nvim", "Neovim")
bind(modKey("SHIFT + N"), "omarchy-launch-tui nvim config", "Neovim Config")
bind(modKey("SHIFT + T"), "walker -m todo", "To-Dos")
bind(modKey("D"), "legcord --toggle", "Discord")
bind(modKey("Y"), "omarchy-launch-or-focus-tui yazi $(omarchy-cmd-terminal-cwd)", "Yazi")

-- Obsidian
bind(
	modKey("O"),
	'omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"',
	"Obsidian"
)
-- -- :TODO: Migrate to obsidian CLI
bind(modKey("SHIFT + O"), 'obsidian "obsidian://daily"', "Obsidian Daily")
-- -- :FIX: Both keybinds will not work after omarchy is migrated to quickshell (walker and elephand will be uninstalled)
bind(modKey("ALT + O"), "elephant m obsidian", "Obsidian Search")
bind(
	modKey("CTRL + SHIFT + O"),
	'bash -c \'v=$(walker -d -I -p "Capture something quickly") && [ -n "$v" ] && obsidian "obsidian://quickadd?choice=Capture%20Daily&value-entry=$(printf "%s" "$v" | sed "s/ /%20/g")"\'',
	"Obsidian Capture daily"
)

-- My custom web apps
bind(modKey("A"), 'omarchy-launch-webapp "https://chatgpt.com"', "ChatGPT")
bind(modKey("SHIFT + C"), 'omarchy-launch-webapp "https://chess.com"', "Chess.com")
-- -- :TODO: use latest version of gemini
bind(
	modKey("SHIFT + A"),
	'omarchy-launch-webapp "https://aistudio.google.com/prompts/new_chat?model=gemini-3-pro-preview"',
	"AI Studio"
)
bind(modKey("SHIFT + M"), 'omarchy-launch-webapp "https://pocketcasts.com/podcasts"', "PocketCasts")
bind(modKey("SHIFT + G"), 'omarchy-launch-webapp "https://github.com/"', "Github")
bind(modKey("R"), 'omarchy-launch-webapp "https://reddit.com/"', "Reddit")
bind(modKey("M"), 'omarchy-launch-webapp "https://open.spotify.com"', "Music")

-- Vim style Navigation
bind(modKey("H"), hl.dsp.focus({ direction = "l" }), "Focus left")
bind(modKey("L"), hl.dsp.focus({ direction = "r" }), "Focus right")
bind(modKey("K"), hl.dsp.focus({ direction = "u" }), "Focus up")
bind(modKey("J"), hl.dsp.focus({ direction = "d" }), "Focus down")

-- Those are keybinds which omarchy has on super k, j, l which have been over written
bind(modKey("SHIFT + K"), "omarchy-menu-keybindings", "Show Keybindings")
bind(modKey("SHIFT + J"), hl.dsp.togglesplit(), "Toggle window split")
bind(modKey("Shift + L"), "omarchy-hyprland-workspace-layout-toggle", "Toggle workspace layout")

-- Configuration
hl.config({
	input = {
		kb_options = "caps:escape,compose:rctrl",
	},
	general = {
		gaps_in = 1,
		gaps_out = 1,
		border_size = 2,
	},
	decoration = {
		rounding = 5,
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			contrast = 0.9,
			brightness = 0.5,
		},
	},
})

-- Exec once
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor ArcDusk-cursors 24or-focus-")
	hl.exec_cmd("hyprctl hyprsunset temperature 3800")
end)
