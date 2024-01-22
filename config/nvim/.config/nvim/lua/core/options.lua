-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

local g = vim.g
local opt = vim.opt
local fn = vim.fn

opt.viewoptions:remove("curdir")
opt.shortmess:append({ a = true, s = true, I = true })
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
opt.timeout = true
opt.timeoutlen = 500

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
if vim.fn.has("nvim-0.10") == 1 then
  g.user_semantic_tokens_enabled = true
else
  g.user_semantic_tokens_enabled = false
end

-- enable notifications
g.user_notifications_enabled = true

-- Process the log level environment variable if set
if vim.env.USER_LOG_LEVEL and type(vim.env.USER_LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.USER_LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    g.user_log_level = lvl
  end
else
  g.user_log_level = vim.log.levels.INFO
end

-- Disable unused builtin plugins
g.loaded_netrw = true
g.loaded_netrwPlugin = true
g.loaded_netrwSettings = true
g.loaded_netrwFileHandlers = true
g.loaded_gzip = true
g.loaded_zip = true
g.loaded_zipPlugin = true
g.loaded_tar = true
g.loaded_tarPlugin = true
g.loaded_tutor_mode_plugin = true
g.loaded_getscript = true
g.loaded_getscriptPlugin = true
g.loaded_vimball = true
g.loaded_vimballPlugin = true
g.loaded_tohtml = true
g.loaded_2html_plugin = true
