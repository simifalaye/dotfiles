local wezterm = require("wezterm")
local platform = require("utils.platform")
local act = wezterm.action

-- stylua: ignore
local keys = {
   -- misc/useful --
   { key = [[\]], mods = "ALT", action = "ActivateCopyMode" },
   { key = "F11", mods = "NONE",    action = act.ToggleFullScreen },
   { key = "F12", mods = "NONE",    action = act.ShowDebugOverlay },
   { key = ":", mods = "LEADER", action = act.ActivateCommandPalette },
   { key = "Space", mods = "LEADER", action = act.ShowLauncher },
   { key = "f",   mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
   {
      key = "u",
      mods = "LEADER",
      action = wezterm.action.QuickSelectArgs({
         label = "open url",
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },
   { key = 't', mods = "LEADER", action = act.SpawnTab({ DomainName = 'ubuntu-24.04-build' }) },

  -- Pane
  {
    key = "h",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  {
    key = "l",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "h",
    mods = "ALT|CTRL",
    action = act.AdjustPaneSize({ "Left", 1 }),
  },
  {
    key = "j",
    mods = "ALT|CTRL",
    action = act.AdjustPaneSize({ "Down", 1 }),
  },
  {
    key = "k",
    mods = "ALT|CTRL",
    action = act.AdjustPaneSize({ "Up", 1 }),
  },
  {
    key = "l",
    mods = "ALT|CTRL",
    action = act.AdjustPaneSize({ "Right", 1 }),
  },
  {
    key = "o",
    mods = "ALT",
    action = act.RotatePanes("CounterClockwise"),
  },
  { key = "O", mods = "ALT", action = act.RotatePanes("Clockwise") },
  { key = "z", mods = "ALT", action = "TogglePaneZoomState" },
  { key = "PageUp",   mods = "NONE",    action = act.ScrollByPage(-0.75) },
  { key = "PageDown", mods = "NONE",    action = act.ScrollByPage(0.75) },

  -- Tab
  { key = "1", mods = "ALT", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT", action = act.ActivateTab(8) },
  { key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },
  { key = "{", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },
  {
    key = ";",
    mods = "ALT",
    action = wezterm.action.ActivateLastTab,
  },

  -- Font
  { key = "=", mods = "CTRL", action = "IncreaseFontSize" },
  { key = "-", mods = "CTRL", action = "DecreaseFontSize" },
  { key = "0", mods = "CTRL", action = "ResetFontSize" },

  -- Key Tables
  {
    key = "p",
    mods = "ALT",
    action = act.ActivateKeyTable({
      name = "pane",
      timeout_milliseconds = 1000,
    }),
  },
  {
    key = "r",
    mods = "ALT",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  {
    key = "'",
    mods = "ALT",
    action = act.ActivateKeyTable({
      name = "tab",
      timeout_milliseconds = 1000,
    }),
  },
}
if platform.is_mac then
  table.insert(keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  table.insert(keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
  table.insert(
    keys,
    { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") }
  )
  table.insert(keys, { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") })
end
-- {
--    key = "F5",
--    mods = "NONE",
--    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
-- },

-- stylua: ignore
local key_tables = {
  pane = {
    {
      key = "b",
      action = wezterm.action_callback(function(_, pane)
        local tab, _ = pane:move_to_new_tab()
        tab:activate()
      end),
    },
    {
      key = "s",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "v",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "h",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "o",
      action = act.RotatePanes("CounterClockwise"),
    },
    { key = "O", action = act.RotatePanes("Clockwise") },
    {
      key = "q",
      action = act.CloseCurrentPane({ confirm = false }),
    },
    { key = "z", action = "TogglePaneZoomState" },
  },
  resize_pane = {
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
  },
  tab = {
    { key = "1", action = act.ActivateTab(0) },
    { key = "2", action = act.ActivateTab(1) },
    { key = "3", action = act.ActivateTab(2) },
    { key = "4", action = act.ActivateTab(3) },
    { key = "5", action = act.ActivateTab(4) },
    { key = "6", action = act.ActivateTab(5) },
    { key = "7", action = act.ActivateTab(6) },
    { key = "8", action = act.ActivateTab(7) },
    { key = "9", action = act.ActivateTab(8) },
    { key = "f", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
    { key = "h", action = act.ActivateTabRelative(-1) },
    { key = "l", action = act.ActivateTabRelative(1) },
    { key = "H", mods = "SHIFT", action = act.MoveTabRelative(-1) },
    { key = "L", mods = "SHIFT", action = act.MoveTabRelative(1) },
    {
      key = "n",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "r",
      action = act.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function(window, _, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
    {
      key = "'",
      action = wezterm.action.ActivateLastTab,
    },
    {
      key = "q",
      action = act.CloseCurrentTab({ confirm = true }),
    },
  },
}

local mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

return {
  disable_default_key_bindings = true,
  -- disable_default_mouse_bindings = true,
  leader = { key = "s", mods = "ALT" },
  keys = keys,
  key_tables = key_tables,
  mouse_bindings = mouse_bindings,
}
