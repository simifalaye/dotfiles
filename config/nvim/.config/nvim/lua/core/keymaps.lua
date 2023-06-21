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
  "Save buffer"
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
m.nnoremap("p", "p`[v`]=", "Paste & format")
m.nnoremap("Q", "@q", "Run q macro")
m.nmap(
  "c.",
  [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "search and replace word under cursor" }
)
m.nmap(
  "c>",
  [[:%s/\V<C-r><C-a>//g<Left><Left>]],
  { desc = "search and replace WORD under cursor" }
)

-- (g) namespace
m.nmap("g-", "yyp^v$r-Vk", "Underline -")
m.nmap("g=", "yyp^v$r=Vk", "Underline =")
m.nnoremap(
  "gm",
  [[<cmd>set nomore<bar>40messages<bar>set more<CR>]],
  "Show message history"
)
m.nnoremap(
  "gO",
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  "Put empty line above"
)
m.nnoremap(
  "go",
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  "Put empty line below"
)
m.nnoremap(
  "gp",
  "'`[' . strpart(getregtype(), 0, 1) . '`]'",
  "Select last changed text",
  { expr = true }
)
m.nnoremap("gx", ":SystemOpen<CR>", "Open link in browser")

-- Toggle windows
m.nnoremap("<F3>", ":ToggleList c<CR>", "Toggle Quickfix")
m.nnoremap("<F4>", ":ToggleList l<CR>", "Toggle Loclist")

-- Leader core groups
m.group("<leader>g", "+git")
m.group("<leader>p", "+plugin")
m.group("<leader>s", "+search")
m.group("<leader>u", "+ui")

-- Leader
m.nnoremap("<leader>!", ":! chmod +x %<CR>", "Make file executable")
m.nnoremap("<leader>pp", ":Lazy<CR>", "Open")
m.nnoremap("<leader>pc", ":Lazy clean<CR>", "Clean")
m.nnoremap("<leader>ph", ":Lazy health<CR>", "Health")
m.nnoremap("<leader>pi", ":Lazy install<CR>", "Install")
m.nnoremap("<leader>ps", ":Lazy sync<CR>", "Sync")
m.nnoremap("<leader>ud", ui.toggle_diagnostics, "Toggle diagnostics")
m.nnoremap("<leader>uf", ui.toggle_foldcolumn, "Toggle foldcolumn")
m.nnoremap("<leader>ug", ui.toggle_signcolumn, "Toggle signcolumn")
m.nnoremap("<leader>ui", ui.set_indent, "Change indent setting")
m.nnoremap("<leader>ul", ui.toggle_statusline, "Toggle statusline")
m.nnoremap("<leader>uL", ui.toggle_codelens, "Toggle CodeLens")
m.nnoremap("<leader>un", ui.change_number, "Change line numbering")
m.nnoremap("<leader>uN", ui.toggle_notifications, "Toggle UI notifications")
m.nnoremap("<leader>up", ui.toggle_paste, "Toggle paste mode")
m.nnoremap("<leader>us", ui.toggle_spell, "Toggle spellcheck")
m.nnoremap("<leader>uS", ui.toggle_conceal, "Toggle conceal")
m.nnoremap("<leader>ut", ui.toggle_tabline, "Toggle tabline")
m.nnoremap("<leader>uw", ui.toggle_wrap, "Toggle wrap")
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
m.xnoremap("il", "g_o0", "in line")
m.xnoremap("al", "$o0", "a line")
m.xnoremap("ie", ":<C-u>normal! G$Vgg0<CR>", "in entire")
m.onoremap("il", ":normal vil<CR>", "in line")
m.onoremap("al", ":normal val<CR>", "a line")
m.onoremap("ie", ":<C-u>normal! GVgg<CR>", "in entire")

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
  "Insert dir path",
  { silent = false }
)
m.cnoremap(
  "<M-.>",
  "<C-r>=fnameescape(expand('%'))<cr>",
  "Insert file path",
  { silent = false }
)

--------------------------------------------------------------------------------
--  Abbreviations
--------------------------------------------------------------------------------

vim.cmd('iab <expr> dts strftime("%F %b %T")')
