--[[

Neovim inint file
Nvim version: 0.11.0+
Maintainer: simifalaye

--]]

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

--
-- Globals
--

--- Inspect the contents of an object very quickly
--- ex. P({1,2,3})
--- @vararg any
--- @return any
_G.dd = function(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

--- Run function now if neovim is started with arguments
---@param f function
_G.now_if_args = function(f)
  if vim.fn.argc(-1) > 0 then
    f()
  else
    vim.schedule(f)
  end
end

--- Custom `vim.pack.add()` hook helper
---@param plugin_name string
---@param kinds string[]
---@param callback function
---@param desc string
_G.on_packchanged = function(plugin_name, kinds, callback, desc)
  if vim.fn.has("nvim-0.12") == 0 then
    return
  end
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback()
  end
  vim.api.nvim_create_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Process the log level environment variable if set
if vim.env.LOG_LEVEL and type(vim.env.LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    vim.g.user_log_level = lvl
  end
else
  vim.g.user_log_level = vim.log.levels.INFO
end

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

--
-- Options
--

-- General
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:25,hor:6"
vim.opt.switchbuf = "usetab"
vim.opt.undofile = true
vim.opt.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.opt.exrc = true
vim.opt.swapfile = false -- TODO: Evaluate

-- UI
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
vim.opt.fillchars = {
  fold = "·",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 1
vim.opt.pumheight = 10
vim.opt.ruler = false
vim.opt.shortmess = "FOSWaco"
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.cursorlineopt = "screenline,number"
vim.opt.breakindentopt = "list:-1"
if vim.fn.has("nvim-0.9") == 1 then
  vim.opt.shortmess = "CFOSWaco"
  vim.opt.splitkeep = "screen"
end
if vim.fn.has("nvim-0.10") == 0 then
  vim.opt.termguicolors = true
end
if vim.fn.has("nvim-0.12") == 1 then
  vim.opt.pummaxwidth = 100

  require("vim._core.ui2").enable({ enable = true, msg = { target = "msg" } })
end

-- Editing
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.formatoptions = "rqnl1j"
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.virtualedit = "block"
-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.completeopt = "menuone,noselect"
if vim.fn.has("nvim-0.11") == 1 then
  vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
end
vim.opt.complete = ".,w,b,kspell"

-- Spelling
vim.opt.spelllang = "en"
vim.opt.spelloptions = "camel"

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
vim.g.markdown_folding = 1
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.foldtext = ""
end

-- Use system clipboard by default
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
