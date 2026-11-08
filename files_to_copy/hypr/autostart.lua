hl.on("hyprland.start", function()
  hl.exec_cmd "setsid uwsm-app -- hyprsunset"
  hl.exec_cmd "cliamp-daemon"
  hl.exec_cmd "setsid uwsm-app -- omniroute serve --daemon --no-open"
end)
