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
vim.opt.confirm = true
vim.opt.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,localoptions"

-- UI
vim.opt.breakindent = true
vim.opt.breakindentopt = "list:-1"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "screenline,number"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:> ,extends:…,precedes:…,nbsp:␣"
vim.opt.fillchars = "eob: "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.pumheight = 10
vim.opt.pummaxwidth = 100
vim.opt.ruler = false
vim.opt.shortmess = "CFOWaco"
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 16
vim.opt.completetimeout = 100
vim.opt.cmdheight = 0

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
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.virtualedit = "block"
-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Completion
vim.opt.complete = ".,w,b,kspell"
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.wildmode = "noselect,full"
vim.opt.wildoptions = "fuzzy,pum"

-- Spelling
vim.opt.spelllang = "en,uk"
vim.opt.spelloptions = "camel"

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
vim.g.markdown_folding = 1
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.foldtext = ""
end

-- Diagnostics
local icons = require("static.icons")
local text_signs = {
  [vim.diagnostic.severity.ERROR] = icons.Font.Diag.Error,
  [vim.diagnostic.severity.WARN] = icons.Font.Diag.Warn,
  [vim.diagnostic.severity.HINT] = icons.Font.Diag.Hint,
  [vim.diagnostic.severity.INFO] = icons.Font.Diag.Info,
}
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = text_signs,
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})
vim.fn.sign_define(
  "DiagnosticSignError",
  { text = icons.Font.Diag.Error, texthl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  { text = icons.Font.Diag.Warn, texthl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo",
  { text = icons.Font.Diag.Info, texthl = "DiagnosticSignInfo" }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  { text = icons.Font.Diag.Hint, texthl = "DiagnosticSignHint" }
)

-- Filetypes
vim.filetype.add({
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
