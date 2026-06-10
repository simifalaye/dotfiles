-- Set require vim options
vim.o.termguicolors = true

vim.pack.add({
  {
    src = "https://github.com/tinted-theming/tinted-nvim",
    version = vim.version.range("v1.*"),
  },
})

-- Load base16 with configuration
require("tinted-nvim").setup({
  default_scheme = "base16-ayu-dark",
  apply_scheme_on_startup = true,
  compile = true,
  capabilities = {
    truecolor = true,
    undercurl = true,
    terminal_colors = true,
  },
  selector = {
    enabled = true,
  },
})

-- vim.pack.add({
--   {
--     src = "https://github.com/catppuccin/nvim",
--     version = vim.version.range("*"),
--   },
-- })
--
-- require("catppuccin").setup({
--   background = { -- :h background
--     light = "latte",
--     dark = "mocha",
--   },
--   term_colors = true,
--   integrations = {
--     fzf = true,
--     gitsigns = true,
--     markdown = true,
--     mini = true,
--     native_lsp = {
--       enabled = true,
--       underlines = {
--         errors = { "undercurl" },
--         hints = { "undercurl" },
--         warnings = { "undercurl" },
--         information = { "undercurl" },
--       },
--     },
--     semantic_tokens = true,
--     treesitter = true,
--     treesitter_context = true,
--     which_key = true,
--   },
--   compile_path = vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "catppuccin"),
-- })
-- vim.cmd.colorscheme("catppuccin")
