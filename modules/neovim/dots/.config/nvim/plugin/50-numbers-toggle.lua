--
-- Neovim global plugin toggling the number display
--

if vim.g.loaded_user_plugin_numbers_toggle then
  return
end
vim.g.loaded_user_plugin_numbers_toggle = true

---@class NumbersToggleOpts
---@field disable? boolean

---@type NumbersToggleOpts
local default_config = {
  disable = false,
}

---@type NumbersToggleOpts | fun():NumbersToggleOpts
vim.g.numbers_toggle = vim.g.numbers_toggle

--- Get configuration
---@return NumbersToggleOpts
local function get_config()
  local opts = type(vim.g.numbers_toggle) == "function" and vim.g.numbers_toggle()
    or vim.g.numbers_toggle
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--- Check if numbers is blocked for the current buf
---@return boolean?
local function numbers_is_blocked()
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

local grp = vim.api.nvim_create_augroup("user_plugin_numbers_toggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "FocusGained", "InsertLeave" }, {
  desc = "Enable relative line numbers",
  group = grp,
  callback = function()
    local config = get_config()
    if config.disable then
      return
    end
    local enabled = not numbers_is_blocked()
    vim.wo.number, vim.wo.relativenumber = enabled, enabled
  end,
})
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertEnter", "TermOpen" }, {
  desc = "Disable relative line numbers",
  group = grp,
  callback = function()
    local config = get_config()
    if config.disable then
      return
    end
    vim.wo.number, vim.wo.relativenumber = not numbers_is_blocked(), false
  end,
})
