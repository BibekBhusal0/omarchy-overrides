local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey
local animations_state_file = os.getenv "HOME" .. "/.config/hypr/animations.state"

local function read_animations_state()
  local file = io.open(animations_state_file, "r")
  if not file then
    return true
  end
  local value = file:read "*l"
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
  hl.config { animations = { enabled = enabled } }
  write_animations_state(enabled)
  hl.exec_cmd(enabled and "notify-send 'Animations Enabled'" or "notify-send 'Animations Disabled'")
end
bind(modKey "ALT + A", toggle_animations, "Toggle Animation")

hl.config { animations = { enabled = read_animations_state() } }
