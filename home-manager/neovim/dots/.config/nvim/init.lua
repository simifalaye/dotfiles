--[[

Neovim inint file
Nvim version: 0.10.0+
Maintainer: simifalaye

--]]

if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

--- Inspect the contents of an object very quickly
--- ex. P({1,2,3})
--- @vararg any
--- @return any
_G.P = function(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

--- Wrapper around a module to require it before using any table members
---@param module string module to use
---@return table a metatable of the module
_G.reqcall = function(module)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(module)[k](...)
      end
    end,
  })
end

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

-- Process the log level environment variable if set
if vim.env.LOG_LEVEL and type(vim.env.LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    vim.g.user_log_level = lvl
  end
else
  vim.g.user_log_level = vim.log.levels.INFO
end

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Configure user plugins
local icons = require("static.icons")
vim.g.user_diagnostics = {
  signs = {
    { name = "DiagnosticSignError", text = icons.font.diagnostics.error },
    { name = "DiagnosticSignWarn", text = icons.font.diagnostics.warn },
    { name = "DiagnosticSignHint", text = icons.font.diagnostics.hint },
    { name = "DiagnosticSignInfo", text = icons.font.diagnostics.info },
  },
  default_mode = 3,
}
vim.g.largefile = { enabled = true }
vim.g.rooter = { enabled = false }

-- Configure lsp options
vim.g.user_lsp_codelens_enabled = true
vim.g.user_lsp_semantic_tokens_enabled = true
vim.g.user_lsp_inlay_hints_enabled = true
vim.g.user_lsp_reference_highlight_enabled = true

-- Disable unused builtin plugins
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true
vim.g.loaded_netrwFileHandlers = true
vim.g.loaded_gzip = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true
vim.g.loaded_tohtml = true
vim.g.loaded_2html_plugin = true

-- Load core modules
require("core.options")
require("core.autocommands")
require("core.commands")
require("core.keymaps")

-- Bootstrap lazy.nvim
local lazypath =
  vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "lazy", "lazy.nvim")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
local colorscheme_ok, colorscheme = pcall(require, "plugins.colorscheme")
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { colorscheme_ok and colorscheme() or "", "default" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
