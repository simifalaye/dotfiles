--
-- Neovim global plugin for handling large files
--

if vim.g.loaded_user_plugin_bigfile then
  return
end
vim.g.loaded_user_plugin_bigfile = true

---@class BigfileStepOpts
---@field size? number
---@field buflocal_name? string

---@class BigfileOpts
---@field disable? boolean
---@field midfile? BigfileStepOpts
---@field bigfile? BigfileStepOpts

---@type BigfileOpts
local default_config = {
  disable = false,
  midfile = {
    size = 48000,
    buflocal_name = "midfile",
  },
  bigfile = {
    size = 1024000,
    buflocal_name = "bigfile",
  },
}

---@type BigfileOpts | fun():BigfileOpts
vim.g.bigfile = vim.g.bigfile

--- Get configuration
---@return BigfileOpts
local function get_config()
  local opts = type(vim.g.bigfile) == "function" and vim.g.bigfile()
    or vim.g.bigfile
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- Main
--

local grp = vim.api.nvim_create_augroup("user_plugin_bigfile", {})
vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Set settings for large files",
  group = grp,
  callback = function(info)
    local config = get_config()
    if config.disable then
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
