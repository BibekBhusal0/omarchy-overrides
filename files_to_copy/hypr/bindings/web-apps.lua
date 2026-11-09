local bind = require("hypr.utils.key").bind
local modKey = require("hypr.utils.key").modKey

-- My custom web apps
bind(modKey "A", 'omarchy-launch-webapp "https://chatgpt.com"', "ChatGPT")
bind(modKey "SHIFT + C", 'omarchy-launch-webapp "https://chess.com"', "Chess.com")
bind(modKey "SHIFT + M", 'omarchy-launch-webapp "https://pocketcasts.com/podcasts"', "PocketCasts")
bind(modKey "SHIFT + G", 'omarchy-launch-webapp "https://github.com/"', "Github")
bind(modKey "R", 'omarchy-launch-webapp "https://reddit.com/"', "Reddit")
bind(modKey "SHIFT + D", 'omarchy-launch-webapp "https://duck.ai/"', "Duck.ai")
