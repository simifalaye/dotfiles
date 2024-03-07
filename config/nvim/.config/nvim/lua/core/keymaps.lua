local map = vim.keymap.set

--------------------------------------------------------------------------------
--  Multi mode
--------------------------------------------------------------------------------

-- Move up/down by visual line
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Fast window navigation
if not vim.g.loaded_user_plugin_tmux then
  map({ "n", "x", "t" }, "<A-h>", "<C-w>h", { desc = "Goto left window" })
  map({ "n", "x", "t" }, "<A-j>", "<C-w>j", { desc = "Goto down window" })
  map({ "n", "x", "t" }, "<A-k>", "<C-w>k", { desc = "Goto up window" })
  map({ "n", "x", "t" }, "<A-l>", "<C-w>l", { desc = "Goto right window" })
  map(
    { "n", "x", "t" },
    "<A-C-h>",
    "<cmd>ResizeWindow l<CR>",
    { desc = "Resize window left" }
  )
  map(
    { "n", "x", "t" },
    "<A-C-j>",
    "<cmd>ResizeWindow d<CR>",
    { desc = "Resize window down" }
  )
  map(
    { "n", "x", "t" },
    "<A-C-k>",
    "<cmd>ResizeWindow u<CR>",
    { desc = "Resize window up" }
  )
  map(
    { "n", "x", "t" },
    "<A-C-l>",
    "<cmd>ResizeWindow r<CR>",
    { desc = "Resize window right" }
  )
end

-- Save
map(
  { "n", "i", "x", "s" },
  "<C-s>",
  "<Esc><cmd>silent! update | redraw<CR>",
  { desc = "Save Buffer" }
)

--------------------------------------------------------------------------------
--  Normal mode
--------------------------------------------------------------------------------

-- Remaps
map("n", "<Esc>", ":noh<CR><Esc>", { silent = true })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "p", "p`[v`]=", { desc = "Paste & Format" })
map("n", "Q", "@q", { desc = "Run q Macro" })

-- (g) namespace
map("n", "g-", "yyp^v$r-Vk", { noremap = false, desc = "Underline -" })
map("n", "g=", "yyp^v$r=Vk", { noremap = false, desc = "Underline =" })
map("n", "g!", ":! chmod +x %<CR>", { desc = "Make File Executable" })
map(
  "n",
  "g<",
  [[<cmd>set nomore<bar>40messages<bar>set more<CR>]],
  { desc = "Show Message History" }
)
map("n", "g>", [[<cmd>messages clear<CR>]], { desc = "Show Message History" })
map("n", "gq.", function()
  -- Save state
  local winview = vim.fn.winsaveview()
  -- Run 'gq' to format the entire document
  vim.cmd([[normal! ggVGgq]])
  -- Restore state
  vim.fn.winrestview(winview)
end, { desc = "Format Document" })
map(
  "n",
  "gv",
  "'`[' . strpart(getregtype(), 0, 1) . '`]'",
  { expr = true, desc = "Select Last Changed Text" }
)
map("n", "gx", ":SystemOpen<CR>", { desc = "System Open" })

-- Toggle windows
map("n", "<F3>", ":ToggleList c<CR>", { silent = true, desc = "Toggle Quickfix" })
map("n", "<F4>", ":ToggleList l<CR>", { silent = true, desc = "Toggle Loclist" })

-- Leader
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "E[x]it Buf" })
map("n", "<leader>X", "<cmd>bd!<CR>", { desc = "E[x]it Buf!" })
map("n", "<leader>pp", "<cmd>Lazy<CR>", { desc = "Open" })
map("n", "<leader>pc", "<cmd>Lazy clean<CR>", { desc = "Clean" })
map("n", "<leader>ph", "<cmd>Lazy health<CR>", { desc = "Health" })
map("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "Install" })
map("n", "<leader>ps", "<cmd>Lazy sync<CR>", { desc = "Sync" })

--------------------------------------------------------------------------------
--  Visual/select/operator mode
--------------------------------------------------------------------------------

-- Remaps
map("v", ".", ":norm.<CR>") -- visual dot repeat
map("v", "$", "g_")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]]) -- visual search
map("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]]) -- visual search
map("v", "Q", ":norm @q<CR>", { silent = false, desc = "Run Q" })
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])
map(
  "x",
  "@",
  ":<C-u>call ExecuteMacroOverVisualRange()<CR>",
  { desc = "Q macro over range", silent = false }
)

-- Text objects
map("x", "al", "$o0", { desc = "A line" })
map("o", "al", "<cmd>normal val<CR>", { desc = "A line" })
map("x", "il", [[<Esc>^vg_]], { desc = "In line" })
map("o", "il", [[<cmd>normal! ^vg_<CR>]], { desc = "In line" })
map("x", "ie", [[gg0oG$]], { desc = "In entire buf" })
map(
  "o",
  "ie",
  [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]],
  { desc = "In entire buf" }
)

--------------------------------------------------------------------------------
--  Insert mode
--------------------------------------------------------------------------------

map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

--------------------------------------------------------------------------------
--  Command mode
--------------------------------------------------------------------------------

-- File/dir name accessors
map(
  "c",
  "<M-,>",
  "<C-r>=fnameescape(expand('%:p:h'))<cr>/",
  { desc = "Insert Dir Path", silent = false }
)
map(
  "c",
  "<M-.>",
  "<C-r>=fnameescape(expand('%'))<cr>",
  { desc = "Insert File Path", silent = false }
)

--------------------------------------------------------------------------------
--  Abbreviations
--------------------------------------------------------------------------------

vim.cmd('iab <expr> dts strftime("%F %b %T")')
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev X! x!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")
vim.cmd("cnoreabbrev X x")
