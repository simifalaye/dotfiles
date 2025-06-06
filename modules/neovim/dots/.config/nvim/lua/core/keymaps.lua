local map = vim.keymap.set

--
-- Multi-mode
--

-- Move through wrapped lines
map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)

--
-- Normal mode
--

-- General
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
  "g[",
  [[<cmd>set nomore<bar>40messages<bar>set more<CR>]],
  { desc = "Show Message History" }
)
map("n", "g]", [[<cmd>messages clear<CR>]], { desc = "Clear Message History" })
map("n", "gQ", function()
  -- Save state
  local winview = vim.fn.winsaveview()
  -- Run 'gq' to format the entire document
  vim.cmd([[normal! ggVGgq]])
  -- Restore state
  vim.fn.winrestview(winview)
end, { desc = "Format Document" })
map("n", "gx", ":SystemOpen<CR>", { desc = "System Open" })
map("n", "gK", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

-- ([/]) namespace
map("n", "[f", function()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
  if wininfo.loclist == 1 then
    vim.cmd("silent! lolder " .. vim.v.count1)
  elseif wininfo.quickfix == 1 then
    vim.cmd("silent! colder " .. vim.v.count1)
  else
    local file = require("utils.fs").file_by_offset(-vim.v.count1)
    if file then
      vim.cmd("edit " .. file)
    end
  end
end, { desc = "Prev file" })
map("n", "]f", function()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
  if wininfo.loclist == 1 then
    vim.cmd("silent! lnewer " .. vim.v.count1)
  elseif wininfo.quickfix == 1 then
    vim.cmd("silent! cnewer " .. vim.v.count1)
  else
    local file = require("utils.fs").file_by_offset(vim.v.count1)
    if file then
      vim.cmd("edit " .. file)
    end
  end
end, { desc = "Next file" })

-- Leader
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
map("n", "<leader>bw", "<cmd>bd!<CR>", { desc = "Wipeout" })

--
-- Visual/Select/Operator mode
--

-- General
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

--
-- Insert mode
--

-- General
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

--
-- Command mode
--

-- General
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

--
-- Abbreviations
--

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
