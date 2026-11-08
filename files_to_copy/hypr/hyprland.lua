-- Omarchy defaults
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")
require("default.hypr.omarchy")

require "hypr.animation"
require "hypr.autostart"
require "hypr.bindings"
require "hypr.env"
require "hypr.input"
require "hypr.looknfeel"
require "hypr.monitors"
require "hypr.vim-keys"
