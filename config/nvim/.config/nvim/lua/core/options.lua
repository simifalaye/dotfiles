-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

-- Process the log level environment variable if set
local log_level = nil
if vim.env.USER_LOG_LEVEL and type(vim.env.USER_LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.USER_LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    log_level = lvl
  end
end

local g = vim.g
local opt = vim.opt
local fn = vim.fn

opt.viewoptions:remove("curdir")
opt.shortmess:append({ s = true, I = true })
opt.backspace:append({ "nostop" })
if fn.has("nvim-0.9") == 1 then
  opt.diffopt:append("linematch:60")
end

opt.cursorline = true
opt.foldlevelstart = 99
opt.helpheight = 10
opt.showmode = false
opt.mousemoveevent = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.cmdheight = 1
opt.pumheight = 16
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.sidescroll = 0
opt.signcolumn = "yes:1"
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.undodir = { require("utils.fs").join_paths(vim.fn.stdpath("data"), "undodir") }
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.conceallevel = 2
opt.autowriteall = true
opt.virtualedit = "block"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"
opt.selection = "old"

-- Timings
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- Recognize numbered lists when formatting text
opt.formatoptions:append("n")

-- Font for GUI
opt.guifont = "MesloLGS NerdFont:h13"

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append("algorithm:histogram")

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Allow local project config
opt.exrc = true

opt.backup = true
opt.backupdir:remove(".")

opt.list = true
opt.listchars = {
  tab = "→ ",
  nbsp = "␣",
  trail = "·",
}
opt.fillchars = {
  fold = "·",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.ts = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.spellcapcheck = ""
opt.spelllang = "en"
opt.spelloptions = "camel"
opt.spellsuggest = "best,9"

g.mapleader = " " -- set leader key
g.maplocalleader = "\\" -- set default local leader key

-- enable or disable automatic codelens refreshing for lsp that support it
g.user_codelens_enabled = true

-- set the visibility of diagnostics in the UI (0=off,1=status,2=virtual,3=all)
g.user_diagnostics_mode = 2

-- enable LSP semantic tokens on startup
g.user_semantic_tokens_enabled = true

-- disable notifications
g.user_notifications_enabled = true

-- notification log levels
g.user_log_level = log_level and log_level or vim.log.levels.INFO

-- disable plugins shipped with neovim
g.loaded_2html_plugin = 1
g.loaded_gzip = 1
g.loaded_matchit = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
