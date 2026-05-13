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
	hl.bind(key, command, { description = description })
end

local function modKey(keys)
	return ("SUPER + " .. keys)
end

-- Unbind some keys which i will not need and which i will overwrite
local unbinds = {
	modKey("SHIFT + M"),
	modKey("SHIFT + D"),
	modKey("SHIFT + G"),
	modKey("SHIFT + W"),
	modKey("SHIFT + SLASH"),
	modKey("SHIFT + P"),
	modKey("SHIFT + B"),
	modKey("SHIFT + A"),
	modKey("SHIFT + E"),
	modKey("SHIFT + ALT + A"),
	modKey("SHIFT + ALT + C"),
	modKey("SHIFT + C"),
	modKey("SHIFT + ALT + G"),
	modKey("SHIFT + CTRL + G"),
	modKey("SHIFT + SHIFT + X"),
	modKey("SHIFT + ALT + X"),
	modKey("SHIFT + T"),
	modKey("SHIFT + N"),
	modKey("O"),
	modKey("CTRL + A"),
	modKey("CTRL + B"),
	modKey("CTRL + W"),
	modKey("P"),
	modKey("SHIFT + O"),
	modKey("H"),
	modKey("J"),
	modKey("K"),
	modKey("L"),
	"ALT + CTRL + K",
}

for _, key in ipairs(unbinds) do
	hl.unbind(key)
end

-- Bindings similar to windows
bind(modKey("E"), "uwsm-app -- nautilus --new-window $(omarchy-cmd-terminal-cwd)", "File manager")
bind("CTRL + SHIFT + ESCAPE", "floating-terminal btop", "Activity")

-- Ruler to measure screen
bind(modKey("SHIFT + R"), "hypruler", "Ruler")

-- -- Pomodoro timer
-- bind(
-- 	modKey("SHIFT + P"),
-- 	"bash -c '[[ $(timeout 0.05s ~/.config/waybar/scripts/timer.sh | head -n1 | jq -r \".class\") =~ (idle|disabled) ]] && ~/.config/waybar/scripts/timer.sh pomo || ~/.config/waybar/scripts/timer.sh toggle'",
-- 	"Pomodoro Timer"
-- )

-- Launch all apps i use
bind(modKey("SLASH"), "start", "Launch All Apps I Use")

-- Toggling the animation
bind(modKey("ALT + A"), "toggle-animation", "Toggle Animation")

-- Pop open window to fit in my screen
bind(modKey("P"), "omarchy-hyprland-window-pop 1300 700", "Pop window out")

-- Open things in floating terminal
bind(modKey("CTRL + A"), "floating-terminal wiremix", "Audio controls")
bind(modKey("CTRL + B"), "floating-terminal bluetui", "Bluetooth controls")
bind(modKey("CTRL + W"), "floating-terminal impala", "Wifi controls")

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
bind(modKey("SHIFT + O"), 'obsidian "obsidian://daily"', "Obsidian Daily")
bind(modKey("ALT + O"), "elephant m obsidian", "Obsidian Search")
bind(
	modKey("CTRL + SHIFT + O"),
	'bash -c \'v=$(walker -d -I -p "Capture something quickly") && [ -n "$v" ] && obsidian "obsidian://quickadd?choice=Capture%20Daily&value-entry=$(printf "%s" "$v" | sed "s/ /%20/g")"\'',
	"Obsidian Capture daily"
)

-- My custom web apps
bind(modKey("A"), 'omarchy-launch-webapp "https://chatgpt.com"', "ChatGPT")
bind(modKey("SHIFT + C"), 'omarchy-launch-webapp "https://chess.com"', "Chess.com")
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

-- Search keyboard shortcuts with SUPER SHIT K
bind(modKey("SHIFT + K"), "omarchy-menu-keybindings", "Show Keybindings")

-- Toggle split with SUPER SHIFT J
bind(modKey("SHIFT + J"), hl.dsp.togglesplit(), "Toggle window split")

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
