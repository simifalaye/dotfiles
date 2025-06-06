--
-- Neovim global plugin for auto-changing directory to the root of an opened buffer
--

if vim.g.loaded_user_plugin_rooter then
  return
end
vim.g.loaded_user_plugin_rooter = true

---@class RooterOpts
---@field enabled? boolean

---@type RooterOpts
local default_config = {
  enabled = true,
}

---@type RooterOpts | fun():RooterOpts
vim.g.rooter = vim.g.rooter

--- Get configuration
---@return RooterOpts
local function get_config()
  local opts = type(vim.g.rooter) == "function" and vim.g.rooter() or vim.g.rooter or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- Main
--

local utils = require("utils.fs")

-- Array of file names indicating root directory. Modify to your liking.
local root_names = utils.root_patterns and utils.root_patterns or { '.git', 'Makefile' }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
  -- Check config
  local config = get_config()
  if not config.enabled then
    return
  end

  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then return end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  vim.fn.chdir(root)
  vim.notify("Changing current dir: " .. root, vim.log.levels.DEBUG)
end

local root_augroup = vim.api.nvim_create_augroup('user_plugin_rooter', {})
vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })
