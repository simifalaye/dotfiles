local wezterm = require("wezterm")
local gpu_adapters = require("utils.gpu-adapter")

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

return {
  max_fps = 120,
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",
  webgpu_preferred_adapter = gpu_adapters:pick_best(),
  underline_thickness = "1.5pt",

  -- color scheme
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

  -- font
  font = wezterm.font("JetBrains Mono"),
  font_size = 13,

  -- cursor
  animation_fps = 120,
  cursor_blink_ease_in = "EaseOut",
  cursor_blink_ease_out = "EaseOut",
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 650,

  -- scrollbar
  enable_scroll_bar = true,

  -- tab bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  tab_max_width = 25,
  show_tab_index_in_tab_bar = true,
  switch_to_last_active_tab_when_closing_tab = true,

  -- window
  window_padding = {
    left = 0,
    right = 0,
    top = 5,
    bottom = 0,
  },
  adjust_window_size_when_changing_font_size = false,

  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 250,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 250,
    target = "CursorColor",
  },
}
