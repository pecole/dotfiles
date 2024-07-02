local wezterm = require "wezterm"
local act = wezterm.action
return {
  -- close pane
  {
    key = "w",
    mods = "CTRL | SHIFT",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- rotate pane
  {
    key = "e",
    mods = "CTRL | SHIFT",
    action = wezterm.action.RotatePanes 'CounterClockwise'
  },
  {
    key = "o",
    mods = "CTRL | SHIFT",
    action = wezterm.action.RotatePanes 'Clockwise'
  },
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
