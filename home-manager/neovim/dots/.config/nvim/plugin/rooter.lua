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
  enabled = false,
}

---@type RooterOpts | fun():RooterOpts
vim.g.rooter = vim.g.rooter

--- Validate config
---@param config table
---@return boolean
local function validate_config(config)
  local ok, err = pcall(vim.validate, {
    enabled = { config.enabled, "boolean" },
  })
  if not ok then
    vim.notify(string.format("Rooter config: %s", err), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- Get configuration
---@return RooterOpts
local function get_config()
  local opts = type(vim.g.rooter) == "function" and vim.g.rooter() or vim.g.rooter or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  if not validate_config(config) then
    return default_config
  end
  return config
end

--
-- Main
--

local rooter_grp = vim.api.nvim_create_augroup("user_plugin_rooter", {})
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileChangedShellPost" }, {
  group = rooter_grp,
  desc = "Automatically change local current directory.",

  pattern = "*",
  callback = function(info)
    local config = get_config()
    if not config.enabled then
      return
    end
    if info.file == "" or vim.bo[info.buf].bt ~= "" then
      return
    end
    local buf = info.buf
    local win = vim.api.nvim_get_current_win()

    vim.schedule(function()
      if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or not vim.api.nvim_win_get_buf(win) == buf
      then
        return
      end
      vim.api.nvim_win_call(win, function()
        local current_dir = vim.fn.getcwd(0)
        local target_dir = vim.fs.root(info.file, require("utils.fs").root_patterns)
          or vim.fs.dirname(info.file)
        local stat = target_dir and vim.uv.fs_stat(target_dir)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if stat and stat.type == "directory" and current_dir ~= target_dir then
          vim.notify("Changing current dir: " .. target_dir, vim.log.levels.DEBUG)
          pcall(vim.cmd.lcd, target_dir)
        end
      end)
    end)
  end,
})
