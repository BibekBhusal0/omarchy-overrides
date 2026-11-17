hl.config {
  general = {
    gaps_in = 1,
    gaps_out = 1,
    border_size = 2,
  },
  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = false,
    },
    blur = {
      enabled = false,
      -- size = 5,
      -- passes = 2,
      -- contrast = 0.9,
      -- brightness = 0.5,
    },
  },
}

-- Remove inner and outer gaps when there is one tiled window
hl.workspace_rule { workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 }

-- Remove the border and rounding from the single tiled window
hl.window_rule {
  match = { float = false, workspace = "w[tv1]" },
  border_size = 0,
  rounding = 0,
}
