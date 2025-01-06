--
-- Neovim global plugin for handling large files
--

if vim.g.loaded_user_plugin_largefile then
  return
end
vim.g.loaded_user_plugin_largefile = true

---@class LargefileStepOpts
---@field size? number
---@field buflocal_name? string

---@class LargefileOpts
---@field enabled? boolean
---@field midfile? LargefileStepOpts
---@field bigfile? LargefileStepOpts

---@type LargefileOpts
local default_config = {
  enabled = false,
  midfile = {
    size = 48000,
    buflocal_name = "midfile",
  },
  bigfile = {
    size = 1024000,
    buflocal_name = "bigfile",
  },
}

---@type LargefileOpts | fun():LargefileOpts
vim.g.largefile = vim.g.largefile

--- Validate config
---@param config table
---@return boolean
local function validate_config(config)
  local ok, err = pcall(vim.validate, {
    enabled = { config.enabled, "boolean" },
    midfile = { config.midfile, "table" },
    bigfile = { config.bigfile, "table" },
  })
  if not ok then
    vim.notify(string.format("Large file config: %s", err), vim.log.levels.ERROR)
    return false
  end
  ok, err = pcall(vim.validate, {
    size = { config.midfile.size, "number" },
    buflocal_name = { config.midfile.buflocal_name, "string" },
  })
  if not ok then
    vim.notify(string.format("Large file config midfile: %s", err), vim.log.levels.ERROR)
    return false
  end
  ok, err = pcall(vim.validate, {
    size = { config.bigfile.size, "number" },
    buflocal_name = { config.bigfile.buflocal_name, "string" },
  })
  if not ok then
    vim.notify(string.format("Large file config bigfile: %s", err), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- Get configuration
---@return LargefileOpts
local function get_config()
  local opts = type(vim.g.largefile) == "function" and vim.g.largefile()
    or vim.g.largefile
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  if not validate_config(config) then
    return default_config
  end
  return config
end

--
-- Main
--

local largefile_grp = vim.api.nvim_create_augroup("user_plugin_largefile", {})
vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Set settings for large files",
  group = largefile_grp,
  callback = function(info)
    local config = get_config()
    if not config.enabled then
      return
    end
    vim.b[config.midfile.buflocal_name] = false
    vim.b[config.bigfile.buflocal_name] = false
    local ok, stat = pcall(vim.loop.fs_stat, info.match)
    if not ok then
      return
    end
    local large_file_groupid = vim.api.nvim_create_augroup("user_large_file", {})
    if stat and stat.size > config.midfile.size then
      vim.b[config.midfile.buflocal_name] = true
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = large_file_groupid,
        buffer = info.buf,
        once = true,
        callback = function()
          vim.schedule(function()
            pcall(vim.treesitter.stop, info.buf)
          end)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {

        group = large_file_groupid,
        buffer = info.buf,
        callback = function(args)
          vim.schedule(function()
            vim.lsp.buf_detach_client(info.buf, args.data.client_id)
          end)
        end,
      })
    end
    if stat and stat.size > config.bigfile.size then
      vim.b[config.bigfile.buflocal_name] = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = large_file_groupid,
        buffer = info.buf,
        once = true,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
    end
  end,
})
