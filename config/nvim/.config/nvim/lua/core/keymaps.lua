local m = require("utils.map")
local ui = require("utils.ui")

-- Multi mode
-------------

-- Move up/down by visual line
m.noremap(
  { "n", "x", "o" },
  "j",
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { expr = true }
)
m.noremap(
  { "n", "x", "o" },
  "k",
  'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
  { expr = true }
)

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
m.nnoremap(
  "g>",
  [[<cmd>set nomore<bar>40messages<bar>set more<CR>]],
  "Show Message History"
)
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
m.nnoremap(
  "gp",
  "'`[' . strpart(getregtype(), 0, 1) . '`]'",
  "Select Last Changed Text",
  { expr = true }
)
m.nnoremap("gx", ":SystemOpen<CR>", "System Open")

-- Toggle windows
m.nnoremap("<F3>", ":ToggleList c<CR>", "Toggle Quickfix")
m.nnoremap("<F4>", ":ToggleList l<CR>", "Toggle Loclist")

-- Leader
m.nnoremap("<leader>!", ":! chmod +x %<CR>", "Make File Executable")
m.nnoremap("<leader><tab>]", "<cmd>tabnext<cr>", "Next Tab")
m.nnoremap("<leader><tab>[", "<cmd>tabprevious<cr>", "Prev Tab")
m.nnoremap("<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
m.nnoremap("<leader><tab>q", "<cmd>tabclose<cr>", "Close Tab")
m.nnoremap("<leader><tab>c", "<cmd>tabclose<cr>", "Close Tab")
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
m.nnoremap("<leader>x", ":bd<CR>", "Delete Buffer")
m.nnoremap("<leader>X", ":bw<CR>", "Wipe Buffer")

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
m.xnoremap("il", "g_o0", "In Line")
m.xnoremap("al", "$o0", "A Line")
m.xnoremap("ie", ":<C-u>normal! G$Vgg0<CR>", "In Entire")
m.onoremap("il", ":normal vil<CR>", "In Line")
m.onoremap("al", ":normal val<CR>", "A Line")
m.onoremap("ie", ":<C-u>normal! GVgg<CR>", "In Entire")

--------------------------------------------------------------------------------
--  Insert mode
--------------------------------------------------------------------------------

-- Readline
m.inoremap("<C-a>", "<C-o>^")
m.inoremap(
  "<C-e>",
  [[col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"]],
  { expr = true }
)
m.inoremap(
  "<C-b>",
  [[getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"]],
  { expr = true }
)
m.inoremap(
  "<C-f>",
  [[col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"]],
  { expr = true }
)
m.inoremap(
  "<C-d>",
  [[col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"]],
  { expr = true }
)

--------------------------------------------------------------------------------
--  Command mode
--------------------------------------------------------------------------------

-- Readline
m.cnoremap("<c-x><c-a>", "<C-a>", "Expand globs")
m.cnoremap("<C-a>", "<Home>")
m.cnoremap("<C-e>", "<End>")
m.cnoremap("<C-b>", "<Left>")
m.cnoremap("<C-d>", "<Del>")
m.cnoremap("<C-k>", [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]])
m.cnoremap(
  "<C-f>",
  [[getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"]],
  { expr = true }
)
m.cnoremap("<C-y>", [[pumvisible() ? "\<C-Y>" : "\<C-R>-"]], { expr = true })

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
