local m = require("utils.map")
local ui = require("utils.ui")

-- Multi mode
-------------

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
m.nmap("g-", "yyp^v$r-Vk", "Underline -")
m.nmap("g=", "yyp^v$r=Vk", "Underline =")
m.nnoremap("g!", ":! chmod +x %<CR>", "Make File Executable")
m.nnoremap(
  "gO",
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  "Put Empty Line Above"
)
m.nnoremap(
  "go",
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  "Put Empty Line Below"
)
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
m.nnoremap("<leader>x", "<cmd>bd<CR>", "E[x]it Buf")
m.nnoremap("<leader>X", "<cmd>bd!<CR>", "E[x]it Buf!")

m.nnoremap("<leader>pp", ":Lazy<CR>", "Open")
m.nnoremap("<leader>pc", ":Lazy clean<CR>", "Clean")
m.nnoremap("<leader>ph", ":Lazy health<CR>", "Health")
m.nnoremap("<leader>pi", ":Lazy install<CR>", "Install")
m.nnoremap("<leader>ps", ":Lazy sync<CR>", "Sync")

m.nnoremap("<leader>ud", ui.toggle_diagnostics, "Toggle Diagnostics")
m.nnoremap("<leader>uf", ui.toggle_foldcolumn, "Toggle Foldcolumn")
m.nnoremap("<leader>ug", ui.toggle_signcolumn, "Toggle Signcolumn")
m.nnoremap("<leader>ui", ui.set_indent, "Change Indent Setting")
m.nnoremap("<leader>ul", ui.toggle_statusline, "Toggle Statusline")
m.nnoremap("<leader>uL", ui.toggle_codelens, "Toggle CodeLens")
m.nnoremap("<leader>un", ui.change_number, "Change Line Numbering")
m.nnoremap("<leader>uN", ui.toggle_notifications, "Toggle UI Notifications")
m.nnoremap("<leader>up", ui.toggle_paste, "Toggle Paste Mode")
m.nnoremap("<leader>us", ui.toggle_spell, "Toggle Spellcheck")
m.nnoremap("<leader>uS", ui.toggle_conceal, "Toggle Conceal")
m.nnoremap("<leader>ut", ui.toggle_tabline, "Toggle Tabline")
m.nnoremap("<leader>uw", ui.toggle_wrap, "Toggle Wrap")

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
