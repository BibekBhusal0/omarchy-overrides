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

-- Some usable keymaps for dictation
if
  o.dictation_installed
  and type(o.dictation_installed) == "function"
  and o.dictation_installed()
then
  -- I use Super + W to close app so this can be safely overwritten
  bind(modKey "Q", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold(
    "CTRL + SPACE",
    "Start dictation (push-to-talk)",
    "omarchy-dictation start",
    "Stop dictation (push-to-talk)",
    "omarchy-dictation stop"
  )
end
