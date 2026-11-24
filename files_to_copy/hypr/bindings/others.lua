local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

-- Ruler to measure screen
bind(modKey "SHIFT + R", "hypruler", "Ruler")

-- Time
bind(modKey "CTRL + T", "omarchy-notification-time", "Show time")

-- Fastest way to suspend
bind(modKey "SHIFT + ESCAPE", "systemctl suspend", "Suspend")

-- Lock
bind(modKey "SHIFT + L", "omarchy-system-lock", "Lock system")

-- Cycle workspace layout instead of the stock Super + L / Super + Shift + L
bind(modKey "I", "toggle-workspace-layout", "Toggle workspace layout (dwindle/scrolling)")

-- Pomodoro (focusd)
bind(modKey "P", "focusd toggle", "Pomodoro toggle")
bind(modKey "SHIFT + P", hl.dsp.window.pseudo(), "Pseudo window")
bind(modKey "PERIOD", hl.dsp.focus { workspace = "previous_per_monitor" }, "Former workspace")

-- Toggle cliamp music source between Lofi and YTM downloads
bind(modKey "ALT + C", "cliamp-daemon toggle", "Toggle cliamp music source (lofi/ytm)")

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
  bind(modKey "Q", "omarchy-dictation toggle", "Toggle dictation")
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
