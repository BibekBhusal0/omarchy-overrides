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
bind("CTRL + SHIFT + ESCAPE", "omarchy-launch-tui btop", "Activity")

-- File manager shortcuts
-- Nautilus is the file manager; change this one line to switch apps.
local file_manager = "nautilus"
local file_manager_cwd = file_manager .. ' "$(terminal-cwd)"'
bind(modKey("E"), file_manager_cwd, "File manager (cwd)")
bind(modKey("CTRL + J"), file_manager .. " ~/Downloads/", "File manager (downloads directory)")
bind(modKey("SHIFT + F"), file_manager, "File manager")
bind(modKey("ALT + SHIFT + F"), file_manager_cwd, "File manager (cwd)")

-- A running Ghostty in single-instance mode ignores --working-directory and
-- reuses its own cwd, so ask it for a new window over IPC instead.
local terminal_cwd = [[uwsm-app -- ghostty +new-window --working-directory="$(terminal-cwd)"]]
bind(modKey("RETURN"), terminal_cwd, "Terminal")

-- Ruler to measure screen
bind(modKey("SHIFT + R"), "hypruler", "Ruler")

-- T3 Code
local t3_launch = "omarchy-launch-or-focus-class com.t3tools.T3Code /home/bibek/.local/share/t3code/T3-Code.AppImage"
bind(modKey("SHIFT + T"), t3_launch, "T3 Code")
-- Copilot key
bind("SUPER + SHIFT + code:201", t3_launch, "T3 Code (copilot key)")
-- Global shortcut for screenshot (needs to configure settings in t3 code)
bind(modKey("SHIFT + CTRL + Print"), hl.dsp.global("com.t3tools.T3Code:capture-window"), "T3 Code snap shot")

-- Launch all apps i use
bind(modKey("SLASH"), "start", "Launch All Apps I Use")
bind(modKey("SHIFT + SLASH"), "uwsm-app -- bitwarden.desktop", "Passwords")

-- Summoning Shell
bind(modKey("ALT + R"), "omarchy-shell shell toggle bibek.readest", "Readest search")
bind(modKey("ALT + M"), "omarchy-shell shell toggle bibek.media", "Media Menu")
bind(modKey("CTRL + Y"), "omarchy-shell shell toggle bibek.ytdl", "Download youtube videos")
bind(modKey("ALT + P"), "omarchy-shell shell toggle bibek.focusd", "Pomodoro popup")
bind(modKey("SHIFT + E"), "omarchy-shell shell summon io.github.weedwhitesandwine.omafetti", "Confetti  🎉")
bind(modKey("CTRL + SHIFT + E"), "omarchy-shell shell toggle omarchy.elsewhen", "World clock")
bind(modKey("SUPER_L"), 'omarchy-shell shell toggle bibek.menu \'{"menu":"apps"}\'', "Apps")
bind(modKey("ALT + SPACE"), 'omarchy-shell shell toggle bibek.menu \'{"menu":"apps"}\'', "Apps")
bind(modKey("CTRL + V"), "omarchy-shell shell toggle io.github.idr4n.clipboard-plus", "Clipboard History")

-- Obsidian
bind(modKey("ALT + O"), "omarchy-shell shell toggle bibek.obsidian-search", "Obsidian Search")
bind(
	modKey("ALT + Y"),
	'omarchy-shell shell toggle bibek.obsidian-search \'{"vaultPath":"~/Youtube/Youtube"}\'',
	"Obsidian Search (Youtube vault)"
)
bind(modKey("ALT + D"), "omarchy-shell shell toggle bibek.obsidian-daily", "Obsidian Daily (tasks)")

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
	[[uwsm-app -- ghostty +new-window --working-directory="$(terminal-cwd)" -e bash -c "tmux new-session -A -s main"]],
	"Tmux"
)

-- Lunching apps
bind(modKey("B"), "omarchy-launch-browser", "Browser")
bind(modKey("SHIFT + B"), "omarchy-launch-browser --private", "Browser (private)")
bind(modKey("M"), "omarchy-launch-or-focus-class Spotify spotify", "Music")
bind(modKey("Z"), "omarchy-launch-or-focus-class zen zen-browser", "Zen")
bind(modKey("N"), "omarchy-launch-tui nvim", "Neovim")
bind(modKey("SHIFT + N"), "omarchy-launch-tui nvim config", "Neovim Config")
bind(modKey("D"), "vesktop --toggle", "Discord")
bind(modKey("SHIFT + S"), "omarchy-launch-or-focus stremio", "Stremio")

-- Obsidian
bind(
	modKey("O"),
	'uwsm-app -- obsidian -disable-gpu --enable-wayland-ime "obsidian://open?vault=vault"',
	"Obsidian (main vault)"
)
bind(
	modKey("Y"),
	'uwsm-app -- obsidian -disable-gpu --enable-wayland-ime "obsidian://open?vault=Youtube"',
	"Obsidian (Youtube vault)"
)
-- -- :TODO: Migrate to obsidian CLI
bind(modKey("SHIFT + O"), 'obsidian "obsidian://daily?vault=vault"', "Obsidian Daily")

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

-- If only Terminal is open then transver vim keys Super + H/J/K/L to terminal (I have setup keymaps in herdr/tmux/nvim so for same style navigation)
local terminal_classes = {
	["com.mitchellh.ghostty"] = true,
	["ghostty"] = true,
	["alacritty"] = true,
	["kitty"] = true,
	["foot"] = true,
	["footclient"] = true,
}

local function is_terminal(win)
	if not win or not win.class then
		return false
	end
	return terminal_classes[win.class] or terminal_classes[win.class:lower()] or false
end

---Check whether Super+H/J/K/L should be forwarded as Ctrl+H/J/K/L into the terminal
---Cases:
---1. Terminal is fullscreen/maximized
---2. Terminal is the only tiled (non-floating) window on the workspace
---3. Terminal spans the full monitor width (forward horizontal nav H/L only)
local function should_forward_to_terminal(dir)
	local win = hl.get_active_window()
	if not is_terminal(win) then
		return false
	end

	-- Fullscreen window
	if win.fullscreen ~= 0 then
		return true
	end

	-- Only tiled window on the workspace
	local ws_wins = hl.get_workspace_windows(win.workspace.id)
	local tiled_count = 0
	for _, w in ipairs(ws_wins) do
		if not w.floating then
			tiled_count = tiled_count + 1
		end
	end
	if tiled_count <= 1 then
		return true
	end

	-- Full-width window: forward left/right since there is no window horizontally
	if dir == "l" or dir == "r" then
		local mon = win.monitor
		if mon and mon.width and mon.scale then
			local is_full_width = win.size.x >= (mon.width / mon.scale) - 20
			if is_full_width then
				return true
			end
		end
	end

	return false
end

local nav_keys = {
	{ super = "H", dir = "l", dir_readable = "Left" },
	{ super = "L", dir = "r", dir_readable = "Right" },
	{ super = "K", dir = "u", dir_readable = "Up" },
	{ super = "J", dir = "d", dir_readable = "Down" },
}
for _, nav in ipairs(nav_keys) do
	local focus_action = hl.dsp.focus({ direction = nav.dir })
	local ctrl_action = hl.dsp.send_shortcut({ mods = "CTRL", key = nav.super })
	bind(modKey(nav.super), function()
		if should_forward_to_terminal(nav.dir) then
			hl.dispatch(ctrl_action)
		else
			hl.dispatch(focus_action)
		end
	end, "Focus " .. nav.dir_readable)
end

-- Overwritten keybinds
bind(modKey("SHIFT + K"), "omarchy-menu-keybindings", "Show Keybindings")
bind(modKey("SHIFT + L"), "toggle-workspace-layout", "Toggle workspace layout (dwindle/scrolling)")
bind(modKey("SHIFT + J"), hl.dsp.layout("togglesplit"), "Toggle window split")

-- Super + Alt + vim keys to resize window
bind(modKey("ALT + H"), hl.dsp.window.resize({ x = -100, y = 0, relative = true }), "Resize window Left")
bind(modKey("ALT + L"), hl.dsp.window.resize({ x = 100, y = 0, relative = true }), "Resize window Right")
bind(modKey("ALT + K"), hl.dsp.window.resize({ x = 0, y = -100, relative = true }), "Resize window Up")
bind(modKey("ALT + J"), hl.dsp.window.resize({ x = 0, y = 100, relative = true }), "Resize window Down")

-- 4.5 binds Alt + Space to dictation, which eats the tmux and herdr prefix.
hl.unbind("ALT + SPACE")

-- 4.5 moved these to new chords; keep the ones i use.
bind(modKey("CTRL + W"), "omarchy-shell shell toggle omarchy.network", "Network")
bind(modKey("CTRL + N"), "omarchy-toggle-nightlight", "Toggle nightlight")

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
	hl.exec_cmd("setsid uwsm-app -- omniroute serve --daemon --no-open")
end)
