---@diagnostic disable: assign-type-mismatch
local o = vim.opt
local g = vim.g

-- Misc
o.clipboard = ""
o.encoding = "utf-8"
o.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
o.syntax = "enable"

-- Indention
o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.shiftround = true
o.smartindent = true
o.softtabstop = 2
o.tabstop = 2

-- Search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.wildignore = o.wildignore
  + { "*/node_modules/*", "*/.git/*", "*/vendor/*" }
o.wildmenu = true

-- Ui
o.cmdheight = 0
o.cursorline = true
o.laststatus = 3 -- global statusline
o.lazyredraw = true
o.list = true
o.listchars = {
  tab = "»·",
  nbsp = "+",
  trail = "·",
  extends = "→",
  precedes = "←",
  eol = nil,
}
o.mouse = "a"
o.number = true
o.relativenumber = true
o.scrolloff = 10
o.sidescrolloff = 10 -- Lines to scroll horizontally
o.showmode = false
o.signcolumn = "yes"
o.splitbelow = true -- Open new split below
o.splitright = true -- Open new split to the right
o.wrap = false
o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.termguicolors = true

-- Backups
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true
if vim.fn.isdirectory(vim.o.undodir) == 0 then
  vim.fn.mkdir(vim.o.undodir, "p")
end

-- Autocomplete
o.completeopt = { "menu", "menuone", "noselect" }
o.shortmess = o.shortmess + { c = true, I = true }

-- Perfomance
o.redrawtime = 1500
o.timeoutlen = 250
o.ttimeoutlen = 10
o.updatetime = 250

-- Filetype
g.do_filetype_lua = 1 -- use filetype.lua when possible

-- Grep
if vim.fn.executable("rg") > 0 then -- Use faster grep if available
  vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
  o.grepformat = o.grepformat ^ { '%f:%l:%c:%m' }
elseif vim.fn.executable("fzf") > 0 then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  o.grepformat = o.grepformat ^ { '%f:%l:%c:%m' }
end
