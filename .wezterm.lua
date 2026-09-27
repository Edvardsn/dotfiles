-- Leader = Ctrl+Space, release, then key (within 1s). Custom shortcuts:
-- Workspaces: s list/switch | n new | r rename | Shift+w close entire workspace (confirm name)
-- Layouts: Ctrl+s save current workspace | Ctrl+r restore saved layout (fresh shells, manual)
-- Panes: | split left/right | - split top/bottom | h/j/k/l focus | arrows resize by 5
--        w close pane (confirm) | z zoom/unzoom | p visual pane picker
-- Tabs: t new | [ previous | Ctrl+] next | , rename
-- Output: ] copy mode; h/j/k/l move, v select, Shift+v select lines, y copy, q/Esc exit
-- Direct: Ctrl+c copy selection/interrupt | Ctrl+v paste. Other WezTerm defaults remain enabled.
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
local sessions = dofile(wezterm.home_dir .. '/.config/wezterm/sessions.lua')

config.default_prog = {
  'C:/Program Files/Git/bin/bash.exe', '--login', '-i',
}
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = true

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(string.format(
    ' Workspace: %s | Pane ID: %s ',
    window:active_workspace(), pane:pane_id()
  ))
end)

config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_duration_ms = 0,
  fade_out_duration_ms = 0,
}
config.ssh_domains = wezterm.default_ssh_domains()
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
{
  key = 'c',
  mods = 'CTRL',
  action = wezterm.action_callback(function(window, pane)
    if window:get_selection_text_for_pane(pane) ~= '' then
      window:perform_action(act.CopyTo 'Clipboard', pane)
      window:perform_action(act.ClearSelection, pane)
    else
      window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
    end
  end),
},
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical {
      domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES' } },
  { key = 'r', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Rename current workspace',
    action = wezterm.action_callback(function(window, _, name)
      if name and name:match('%S') then
        local ok, err = pcall(wezterm.mux.rename_workspace, window:active_workspace(), name)
        if not ok then window:toast_notification('Rename failed', tostring(err), nil, 4000) end
      end
    end),
  } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'p', mods = 'LEADER', action = act.PaneSelect },
  { key = 'LeftArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = ']', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(1) },
  { key = ',', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Rename current tab',
    action = wezterm.action_callback(function(_, pane, name)
      if name then pane:tab():set_title(name) end
    end),
  } },
  { key = 's', mods = 'LEADER|CTRL', action = wezterm.action_callback(function(window)
    local ok, err = pcall(sessions.save, window)
    if not ok then window:toast_notification('Save failed', tostring(err), nil, 6000) end
  end) },
  { key = 'r', mods = 'LEADER|CTRL', action = wezterm.action_callback(sessions.pick) },
  { key = 'W', mods = 'LEADER|SHIFT', action = wezterm.action_callback(function(window, pane)
    local workspace = window:active_workspace()
    window:perform_action(act.PromptInputLine {
      description = 'Close ALL panes in workspace "' .. workspace .. '"? Type its name to confirm:',
      action = wezterm.action_callback(function(_, _, name)
        if name ~= workspace then return end
        local panes = {}
        for _, win in ipairs(wezterm.mux.all_windows()) do
          if win:get_workspace() == workspace then
            for _, tab in ipairs(win:tabs()) do
              for _, target in ipairs(tab:panes()) do
                table.insert(panes, tostring(target:pane_id()))
              end
            end
          end
        end
        for _, id in ipairs(panes) do
          local ok, _, err = wezterm.run_child_process {
            wezterm.executable_dir .. '/wezterm.exe', 'cli', '--no-auto-start', 'kill-pane', '--pane-id', id,
          }
          if not ok then wezterm.log_error(err) end
        end
      end),
    }, pane)
  end) },
  { key = 'n', mods = 'LEADER', action = act.PromptInputLine {
      description = 'New workspace name',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
  } },
}
return config
