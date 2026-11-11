local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

-- Ruler to measure screen
bind(modKey "SHIFT + R", "hypruler", "Ruler")

-- Time
bind(modKey "CTRL + T", "omarchy-notification-time", "Show time")

-- Fastest way to suspend
bind(modKey "SHIFT + ESCAPE", "systemctl suspend", "Suspend")

-- Pomodoro (focusd)
bind(modKey "P", "focusd toggle", "Pomodoro toggle")
bind(modKey "SHIFT + P", hl.dsp.window.pseudo(), "Pseudo window")

local function dictation_installed()
  local pipe = io.popen("omarchy-default-dictation 2>/dev/null", "r")
  local backend = pipe and pipe:read "*l"
  if pipe then
    pipe:close()
  end
  return backend ~= nil and backend:match "^[%w%-]+$" ~= nil and not o.cmd_missing(backend)
end

-- Some usable keymaps for dictation
if dictation_installed then
  -- I use Super + W to close app so this can be safely overwritten
  bind(modKey "Q",  "omarchy-dictation toggle", "Toggle dictation")
  o.bind_hold(
    "CTRL + SPACE",
    "Start dictation (push-to-talk)",
    "omarchy-dictation start",
    "Stop dictation (push-to-talk)",
    "omarchy-dictation stop"
  )
else
  hl.unbind(modKey "Q")
  hl.unbind "CTRL + SPACE"
end
