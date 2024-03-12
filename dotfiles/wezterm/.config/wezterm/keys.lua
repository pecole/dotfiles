local wezterm = require "wezterm"
local act = wezterm.action
return {
  -- split pane
  {
    key = '_',
    mods = 'CTRL | SHIFT',
    action = act.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = '|',
    mods = 'CTRL | SHIFT',
    action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  -- move pane
  {
    key = 'H',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'L',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'K',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'J',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Down',
  }
}
