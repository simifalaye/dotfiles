vim.opt_local.wrap = false
vim.opt_local.spell = true
vim.opt_local.textwidth = 72

-- Fix bold and italic colors
vim.cmd([[
highlight def link htmlBold Tag
highlight def link htmlItalic Keyword
]])
