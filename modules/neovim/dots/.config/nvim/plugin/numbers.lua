--
-- Neovim global plugin for enabling and disabling relative line numbers
--

if vim.g.loaded_user_plugin_numbers then
  return
end
vim.g.loaded_user_plugin_numbers = true

---@class NumbersOpts
---@field disable? boolean

---@type NumbersOpts
local default_config = {
  disabled = false,
  excluded_filetypes = {},
}

---@type NumbersOpts | fun():NumbersOpts
vim.g.numbers = vim.g.numbers

--- Get configuration
---@return NumbersOpts
local function get_config()
  local opts = type(vim.g.numbers) == "function" and vim.g.numbers()
    or vim.g.numbers
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

local function is_blocked()
  local win_type = vim.fn.win_gettype()
  if not vim.api.nvim_buf_is_valid(0) and not vim.api.nvim_buf_is_loaded(0) then
    return true
  end
  if win_type == "command" or vim.wo.diff or vim.wo.previewwindow then
    return true
  end
  if vim.fn.win_gettype() == "popup" then
    return true
  end

  local decs = require("utils.ui").decorations.get({
    ft = vim.bo.ft,
    bt = vim.bo.bt,
    setting = "number",
  })
  return decs and (decs.ft == false or decs.bt == false)
end

--
-- Main
--

local numbers_group_id =
  vim.api.nvim_create_augroup("user_plugin_numbers", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "FocusGained", "InsertLeave" }, {
  desc = "Enable relative line numbers",
  group = numbers_group_id,
  callback = function()
    local config = get_config()
    if config.disable then
      return
    end
    local enabled = not is_blocked()
    vim.wo.number, vim.wo.relativenumber = enabled, enabled
  end,
})
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertEnter", "TermOpen" }, {
  desc = "Disable relative line numbers",
  group = numbers_group_id,
  callback = function()
    local config = get_config()
    if config.disable then
      return
    end
    vim.wo.number, vim.wo.relativenumber = not is_blocked(), false
  end,
})
