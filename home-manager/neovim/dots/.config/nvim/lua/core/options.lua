local opt = vim.opt
local fn = vim.fn

opt.viewoptions:remove("curdir")
opt.shortmess:append({ a = true, s = true })
opt.backspace:append({ "nostop" })
if fn.has("nvim-0.9") == 1 then
  opt.diffopt:append("linematch:60")
end

opt.cursorline = true
opt.helpheight = 10
opt.showmode = false
opt.mousemoveevent = true
opt.number = true
opt.relativenumber = true
opt.ruler = false
opt.cmdheight = 1
opt.pumheight = 16
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.sidescroll = 0
opt.signcolumn = "yes:1"
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.undodir = {
  vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "undodir"),
}
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.conceallevel = 2
opt.autowriteall = true
opt.virtualedit = "block"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"
opt.selection = "old"

-- Folds
opt.foldcolumn = "0"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Timings
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- Recognize numbered lists when formatting text
opt.formatoptions:append("n")

-- Font for GUI
opt.guifont = "MesloLGS NerdFont:h13"

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append("algorithm:histogram")

-- Use system clipboard by default
opt.clipboard = "unnamedplus"

-- Allow local project config
opt.exrc = true

opt.backup = false
opt.writebackup = false

opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
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

-- Preview substitutions live, as you type!
opt.inccommand = "split"
