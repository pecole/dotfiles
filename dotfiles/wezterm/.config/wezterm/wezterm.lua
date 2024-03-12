-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.color_scheme = 'Deafened (terminal.sexy)'
config.window_background_opacity = 0.85

-- colors
config.colors = require('colors')

-- keys
config.keys = require('keys')

-- font size
config.font_size = 14.0

config.window_decorations = 'RESIZE'

-- and finally, return the configuration to wezterm
return config
