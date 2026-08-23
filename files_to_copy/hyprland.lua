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
	-- Unbind before binding new to avoid conflicts.
	hl.unbind(key)
	hl.bind(key, command, { description = description })
end

local function modKey(keys)
	return ("SUPER + " .. keys)
end

-- Bindings similar to windows
bind(modKey("E"), "uwsm-app -- nautilus --new-window $(omarchy-cmd-terminal-cwd)", "File manager")
bind("CTRL + SHIFT + ESCAPE", "omarchy-launch-tui btop", "Activity")

-- Ruler to measure screen
bind(modKey("SHIFT + R"), "hypruler", "Ruler")

-- Launch all apps i use
bind(modKey("SLASH"), "start", "Launch All Apps I Use")
bind(modKey("SHIFT + SLASH"), "uwsm-app -- bitwarden.desktop", "Passwords")

-- Summoning Shell
bind(modKey("ALT + R"), "omarchy-shell shell toggle bibek.readest", "Readest search")
bind(modKey("ALT + O"), "omarchy-shell shell toggle bibek.obsidian-search", "Obsidian Search")
bind(modKey("ALT + M"), "omarchy-shell shell toggle bibek.media", "Media Menu")
bind(modKey("ALT + Y"), "omarchy-shell shell toggle bibek.ytdl", "Download youtube videos")
bind(modKey("ALT + P"), "omarchy-shell shell toggle bibek.focusd", "Pomodoro popup")

local animations_state_file = os.getenv("HOME") .. "/.config/hypr/animations.state"

local function read_animations_state()
	local file = io.open(animations_state_file, "r")
	if not file then
		return true
	end
	local value = file:read("*l")
	file:close()
	return value ~= "false"
end

local function write_animations_state(enabled)
	local file = io.open(animations_state_file, "w")
	if not file then
		return
	end
	file:write(enabled and "true\n" or "false\n")
	file:close()
end

local function toggle_animations()
	local enabled = not read_animations_state()
	hl.config({ animations = { enabled = enabled } })
	write_animations_state(enabled)
	hl.exec_cmd(enabled and "notify-send 'Animations Enabled'" or "notify-send 'Animations Disabled'")
end
bind(modKey("ALT + A"), toggle_animations, "Toggle Animation")

bind(
	modKey("ALT + RETURN"),
	[[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux new-session -A -s main"]],
	"Tmux"
)

-- Lunching apps
bind(modKey("B"), "omarchy-launch-browser", "Browser")
bind(modKey("SHIFT + B"), "omarchy-launch-browser --private", "Browser (private)")
bind(modKey("M"), "omarchy-launch-or-focus spotify", "Music")
bind(modKey("Z"), "omarchy-launch-or-focus zen-browser", "Zen")
bind(modKey("N"), "omarchy-launch-tui nvim", "Neovim")
bind(modKey("SHIFT + N"), "omarchy-launch-tui nvim config", "Neovim Config")
bind(modKey("D"), "vesktop --toggle", "Discord")
bind(modKey("Y"), "omarchy-launch-tui yazi $(omarchy-cmd-terminal-cwd)", "Yazi")

-- Obsidian
bind(
	modKey("O"),
	'omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"',
	"Obsidian"
)
-- -- :TODO: Migrate to obsidian CLI
bind(modKey("SHIFT + O"), 'obsidian "obsidian://daily"', "Obsidian Daily")
-- -- :FIX: Will not work aftetr quattro
-- bind(
-- 	modKey("CTRL + SHIFT + O"),
-- 	'bash -c \'v=$(walker -d -I -p "Capture something quickly") && [ -n "$v" ] && obsidian "obsidian://quickadd?choice=Capture%20Daily&value-entry=$(printf "%s" "$v" | sed "s/ /%20/g")"\'',
-- 	"Obsidian Capture daily"
-- )

bind(modKey("bracketleft"), "omarchy-shell media previous", "Previous Media")
bind(modKey("bracketright"), "omarchy-shell media next", "Next Media")
bind(modKey("SHIFT + ESCAPE"), "systemctl suspend", "Suspend")

-- My custom web apps
bind(modKey("A"), 'omarchy-launch-webapp "https://chatgpt.com"', "ChatGPT")
bind(modKey("SHIFT + C"), 'omarchy-launch-webapp "https://chess.com"', "Chess.com")
bind(
	modKey("SHIFT + A"),
	'omarchy-launch-webapp "https://aistudio.google.com/prompts/new_chat?model=gemini-3.1-pro-preview"',
	"AI Studio"
)
bind(modKey("SHIFT + M"), 'omarchy-launch-webapp "https://pocketcasts.com/podcasts"', "PocketCasts")
bind(modKey("SHIFT + G"), 'omarchy-launch-webapp "https://github.com/"', "Github")
bind(modKey("R"), 'omarchy-launch-webapp "https://reddit.com/"', "Reddit")
bind(modKey("SHIFT + D"), 'omarchy-launch-webapp "https://duck.ai/"', "Duck.ai")

-- Pomodoro (focusd)
bind(modKey("P"), "focusd toggle", "Pomodoro toggle")
bind(modKey("SHIFT + P"), hl.dsp.window.pseudo(), "Pseudo window")

-- Vim style Navigation
bind(modKey("H"), hl.dsp.focus({ direction = "l" }), "Focus left")
bind(modKey("L"), hl.dsp.focus({ direction = "r" }), "Focus right")
bind(modKey("K"), hl.dsp.focus({ direction = "u" }), "Focus up")
bind(modKey("J"), hl.dsp.focus({ direction = "d" }), "Focus down")

-- Overwritten keybinds
bind(modKey("SHIFT + K"), "omarchy-menu-keybindings", "Show Keybindings")
bind(modKey("SHIFT + L"), "omarchy-hyprland-workspace-layout-toggle", "Toggle workspace layout")
bind(modKey("SHIFT + J"), hl.dsp.layout("togglesplit"), "Toggle window split")

-- Super + Alt + vim keys to resize window
bind(modKey("ALT + H"), hl.dsp.window.resize({ x = -100, y = 0, relative = true }), "Resize window Left")
bind(modKey("ALT + L"), hl.dsp.window.resize({ x = 100, y = 0, relative = true }), "Resize window Right")
bind(modKey("ALT + K"), hl.dsp.window.resize({ x = 0, y = -100, relative = true }), "Resize window Up")
bind(modKey("ALT + J"), hl.dsp.window.resize({ x = 0, y = 100, relative = true }), "Resize window Down")

-- Configuration
hl.config({
	input = {
		kb_options = "caps:escape,compose:ralt",
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
	animations = {
		enabled = read_animations_state(),
	},
})

-- Environment variables
hl.env("XCURSOR_THEME", "ArcDusk-cursors")
hl.env("XCURSOR_SIZE", "24")

-- Exec once
hl.on("hyprland.start", function()
	hl.exec_cmd("setsid uwsm-app -- hyprsunset")
	hl.exec_cmd("cliamp-daemon")
end)
