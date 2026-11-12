hl.config { input = { kb_options = "caps:escape,compose:ralt" } }

-- Workspaces
hl.gesture { fingers = 3, direction = "horizontal", action = "workspace" }

-- Media: swipe up for next, down for previous
hl.gesture {
  fingers = 3,
  direction = "down",
  action = function()
    hl.exec_cmd "omarchy-shell media next"
  end,
}
hl.gesture {
  fingers = 3,
  direction = "up",
  action = function()
    hl.exec_cmd "omarchy-shell media previous"
  end,
}

-- Move the focused window to the literal next/previous workspace and follow it.
-- "m+1" jumps to the next *existing* workspace, so use the id instead.
local function move_window_to_offset(offset)
  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  local target = math.max(workspace.id + offset, 1)
  hl.dispatch(hl.dsp.window.move { workspace = tostring(target), follow = true })
end

hl.gesture {
  fingers = 3,
  direction = "right",
  mods = "SUPER",
  action = function()
    move_window_to_offset(1)
  end,
}
hl.gesture {
  fingers = 3,
  direction = "left",
  mods = "SUPER",
  action = function()
    move_window_to_offset(-1)
  end,
}

-- Finger pinch to zoom
hl.gesture { fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" }
