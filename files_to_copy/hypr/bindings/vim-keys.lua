local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

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
---4. There is only one monitor available
local function should_forward_to_terminal(dir)
  local monitors = hl.get_monitors()
  if #monitors > 1 then
    return false
  end

  local win = hl.get_active_window()
  if not is_terminal(win) then
    return false
  end

  if win == nil then
    return
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
  local focus_action = hl.dsp.focus { direction = nav.dir }
  local ctrl_action = hl.dsp.send_shortcut { mods = "CTRL", key = nav.super }
  bind(modKey(nav.super), function()
    if should_forward_to_terminal(nav.dir) then
      hl.dispatch(ctrl_action)
    else
      hl.dispatch(focus_action)
    end
  end, "Focus " .. nav.dir_readable)
end

-- Overwritten keybinds
bind(modKey "SHIFT + K", "omarchy-menu-keybindings", "Show Keybindings")
bind(modKey "SHIFT + L", "toggle-workspace-layout", "Toggle workspace layout (dwindle/scrolling)")
bind(modKey "SHIFT + J", hl.dsp.layout "togglesplit", "Toggle window split")

-- Super + Alt + vim keys to resize window
local resize = hl.dsp.window.resize
bind(modKey "ALT + H", resize { x = -100, y = 0, relative = true }, "Resize window Left")
bind(modKey "ALT + L", resize { x = 100, y = 0, relative = true }, "Resize window Right")
bind(modKey "ALT + K", resize { x = 0, y = -100, relative = true }, "Resize window Up")
bind(modKey "ALT + J", resize { x = 0, y = 100, relative = true }, "Resize window Down")
