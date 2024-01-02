local m = require("utils.map")

--------------------------------------------------------------------------------
--  Multi mode
--------------------------------------------------------------------------------

-- Move up/down by visual line
m.noremap({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
m.noremap({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Save
m.noremap(
  { "n", "i", "x", "s" },
  "<C-s>",
  "<Esc><cmd>silent! update | redraw<CR>",
  "Save Buffer"
)

--------------------------------------------------------------------------------
--  Normal mode
--------------------------------------------------------------------------------

-- Remaps
m.nnoremap("<Esc>", ":noh<CR><Esc>")
m.nnoremap("/", "ms/\\v", { silent = false })
m.nnoremap("?", "ms?\\v", { silent = false })
m.nnoremap("n", "nzzzv")
m.nnoremap("N", "Nzzzv")
m.nnoremap("p", "p`[v`]=", "Paste & Format")
m.nnoremap("Q", "@q", "Run q Macro")

-- (g) namespace
m.group("g", "+goto")
m.nmap("g-", "yyp^v$r-Vk", "Underline -")
m.nmap("g=", "yyp^v$r=Vk", "Underline =")
m.nnoremap("g!", ":! chmod +x %<CR>", "Make File Executable")
m.nnoremap(
  "g>",
  [[<cmd>set nomore<bar>40messages<bar>set more<CR>]],
  "Show Message History"
)
m.nnoremap("g<", [[<cmd>messages clear<CR>]], "Show Message History")
m.nnoremap("gq.", function()
  -- Save state
  local winview = vim.fn.winsaveview()
  -- Run 'gq' to format the entire document
  vim.cmd([[normal! ggVGgq]])
  -- Restore state
  vim.fn.winrestview(winview)
end, "Format Document")
m.nnoremap(
  "gv",
  "'`[' . strpart(getregtype(), 0, 1) . '`]'",
  "Select Last Changed Text",
  { expr = true }
)
m.nnoremap("gx", ":SystemOpen<CR>", "System Open")

-- Toggle windows
m.nnoremap("<F3>", ":ToggleList c<CR>", "Toggle Quickfix")
m.nnoremap("<F4>", ":ToggleList l<CR>", "Toggle Loclist")

-- Leader
m.group("<leader>p", "+plugins")
m.nnoremap("<leader>x", "<cmd>bd<CR>", "E[x]it Buf")
m.nnoremap("<leader>X", "<cmd>bd!<CR>", "E[x]it Buf!")
m.nnoremap("<leader>pp", ":Lazy<CR>", "Open")
m.nnoremap("<leader>pc", ":Lazy clean<CR>", "Clean")
m.nnoremap("<leader>ph", ":Lazy health<CR>", "Health")
m.nnoremap("<leader>pi", ":Lazy install<CR>", "Install")
m.nnoremap("<leader>ps", ":Lazy sync<CR>", "Sync")

--------------------------------------------------------------------------------
--  Visual/select/operator mode
--------------------------------------------------------------------------------

-- Remaps
m.vnoremap(".", ":norm.<CR>") -- visual dot repeat
m.vnoremap("$", "g_")
m.vnoremap("<", "<gv")
m.vnoremap(">", ">gv")
m.xnoremap("*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]]) -- visual search
m.xnoremap("#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]]) -- visual search
m.vnoremap("Q", ":norm @q<CR>", "Run Q silent", { silent = false })
m.xnoremap("p", "P") -- paste no copy
m.xnoremap("P", "p") -- paste and copy
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])
m.xnoremap(
  "@",
  ":<C-u>call ExecuteMacroOverVisualRange()<CR>",
  "Q macro over range",
  { silent = false }
)

-- Text objects
m.xnoremap("al", "$o0", "A line")
m.onoremap("al", "<cmd>normal val<CR>", "A line")
m.xnoremap("il", [[<Esc>^vg_]], "In line")
m.onoremap("il", [[<cmd>normal! ^vg_<CR>]], "In line")
m.xnoremap("ie", [[gg0oG$]], "In entire buf")
m.onoremap(
  "ie",
  [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]],
  "In entire buf"
)

--------------------------------------------------------------------------------
--  Insert mode
--------------------------------------------------------------------------------

m.inoremap(",", ",<c-g>u")
m.inoremap(".", ".<c-g>u")
m.inoremap(";", ";<c-g>u")

--------------------------------------------------------------------------------
--  Command mode
--------------------------------------------------------------------------------

-- File/dir name accessors
m.cnoremap(
  "<M-,>",
  "<C-r>=fnameescape(expand('%:p:h'))<cr>/",
  "Insert Dir Path",
  { silent = false }
)
m.cnoremap(
  "<M-.>",
  "<C-r>=fnameescape(expand('%'))<cr>",
  "Insert File Path",
  { silent = false }
)

--------------------------------------------------------------------------------
--  Abbreviations
--------------------------------------------------------------------------------

vim.cmd('iab <expr> dts strftime("%F %b %T")')
