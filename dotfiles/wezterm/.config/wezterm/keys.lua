local wezterm = require "wezterm"
local act = wezterm.action
return {
  -- full screen
  {
    key = "f",
    mods = "CTRL | SHIFT",
    action = act.ToggleFullScreen,
  },
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
    key = 'h',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL | SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
  -- create workspace
  {
    key = 'c',
    mods = 'CTRL | SHIFT',
    action = act.PromptInputLine {
      description = 'Create new workspace:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  -- switch workspace
  {
    key = 's',
    mods = 'CTRL | SHIFT',
    action = wezterm.action_callback (function(window, pane)
      -- get workspace list
      local workspaces = {}
      for i, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, {
          id = name,
          label = string.format('%d: %s', i, name),
        })
      end
      local current = wezterm.mux.get_active_workspace()
      -- launch select menu
      window:perform_action(act.InputSelector {
        action = wezterm.action_callback(function(_, _, id, label)
          if not id and not label then
            wezterm.log_info 'Workspace selection canceled'
          else
            window:perform_action( act.SwitchToWorkspace { name = id }, pane)
          end
        end),
        title = 'Select workspace',
        choices = workspaces,
        fuzzy = true,
        fuzzy_description = string.format("Select workspace: %s -> ", current),
      }, pane)
    end),
  },
  -- rename workspace
  {
    key = 'r',
    mods = 'CTRL | SHIFT',
    action = act.PromptInputLine {
      description = string.format("Rename workspace: %s -> ", wezterm.mux.get_active_workspace()),
      action = wezterm.action_callback(function(_, _, line)
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },
}
