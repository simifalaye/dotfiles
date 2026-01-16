--
-- Neovim global plugin for changing the background based on a theme file
--

if vim.g.loaded_user_plugin_theme_watcher then
  return
end
vim.g.loaded_user_plugin_theme_watcher = true

---@class ThemeWatcherOpts
---@field disable? boolean
---@field theme_file? string

---@type ThemeWatcherOpts
local default_config = {
  disable = false,
  theme_file = "/tmp/.os-theme",
}

---@type ThemeWatcherOpts | fun():ThemeWatcherOpts
vim.g.theme_watcher = vim.g.theme_watcher

--- Get configuration
---@return ThemeWatcherOpts
local function get_config()
  local opts = type(vim.g.theme_watcher) == "function" and vim.g.theme_watcher()
    or vim.g.theme_watcher
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- Main
--

local fs = require("utils.fs")
local config = get_config()

local function set_theme(file)
  if not fs.file_exists(file) then
    return
  end
  local theme = fs.read_file(file)
  if theme and theme:find("light") then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

-- Set on startup
set_theme(config.theme_file)

fs.watch(config.theme_file, {
  on_event = function(_, _, _)
    vim.schedule(function()
      set_theme(config.theme_file)
    end)
  end,
})
