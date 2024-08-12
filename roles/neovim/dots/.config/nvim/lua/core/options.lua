local g = vim.g
local opt = vim.opt
local fn = vim.fn

--
-- Globals
--

-- Set leader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- enable or disable automatic codelens refreshing for lsp that support it
g.user_codelens_enabled = true

-- set the visibility of diagnostics in the UI (0=off,1=+status,2=+signs,3=all)
g.user_diagnostics_mode = 2

-- enable LSP semantic tokens on startup
g.user_semantic_tokens_enabled = true

-- enable or disable inlay hints
g.user_inlay_hints_enabled = true

-- enable rooter
g.user_rooter_enabled = true

-- Process the log level environment variable if set
if vim.env.USER_LOG_LEVEL and type(vim.env.USER_LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.USER_LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    g.user_log_level = lvl
  end
else
  g.user_log_level = vim.log.levels.INFO
end

-- Set diagnostic signs
local icons = require("static.icons")
local signs = {
  { name = "DiagnosticSignError", text = icons.font.diagnostics.error },
  { name = "DiagnosticSignWarn", text = icons.font.diagnostics.warn },
  { name = "DiagnosticSignHint", text = icons.font.diagnostics.hint },
  { name = "DiagnosticSignInfo", text = icons.font.diagnostics.info },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Diagnostics
local default_diagnostics = {
  virtual_text = true,
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
_G.user_diagnostics = {
  -- diagnostics off
  [0] = vim.tbl_deep_extend("force", default_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }),
  -- status only
  vim.tbl_deep_extend(
    "force",
    default_diagnostics,
    { virtual_text = false, signs = false }
  ),
  -- virtual text off, signs on
  vim.tbl_deep_extend("force", default_diagnostics, { virtual_text = false }),
  -- all diagnostics on
  default_diagnostics,
}
vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])

-- Use osc52 over SSH
if vim.env.SSH_TTY then
  -- Use osc52 when over ssh
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
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

--
-- Options
--

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
