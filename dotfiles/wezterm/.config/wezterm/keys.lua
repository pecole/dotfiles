local wezterm = require "wezterm"
return {
  -- split pane
  {
    key = '_',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = '|',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
}
