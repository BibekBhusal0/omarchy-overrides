local M = {}
local exec = hl.dsp.exec_cmd

---Wrapper for setting keybinds
---@param key string  the key or the key combination
---@param cmd string|function|HL.Dispatcher The command to be executed when key is pressed
---@param description string  description of the keymap
function M.bind(key, cmd, description)
  local command = cmd
  if type(cmd) == "string" then
    command = exec(cmd)
  end
  -- Unbind before binding new to avoid conflicts.
  hl.unbind(key)
  hl.bind(key, command, { description = description })
end

function M.modKey(keys)
  return ("SUPER + " .. keys)
end

return M
