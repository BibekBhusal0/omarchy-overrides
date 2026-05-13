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

-- Bindings similar to windows
bind(modKey("E"), "uwsm-app -- nautilus --new-window $(omarchy-cmd-terminal-cwd)", "File explorer")
bind("Ctrl + Shitf + Escape", "omarchy-launch-or-focus-tui btop", "Task Manager")
