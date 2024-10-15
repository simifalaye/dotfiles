local map = vim.keymap.set

--
-- Multi-mode
--

-- Move up/down by visual line
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Save
map(
  { "n", "i", "x", "s" },
  "<C-s>",
  "<Esc><cmd>silent! update | redraw<CR>",
  { desc = "Save Buffer" }
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
map("n", "gq.", function()
  -- Save state
  local winview = vim.fn.winsaveview()
  -- Run 'gq' to format the entire document
  vim.cmd([[normal! ggVGgq]])
  -- Restore state
  vim.fn.winrestview(winview)
end, { desc = "Format Document" })
map("n", "gx", ":SystemOpen<CR>", { desc = "System Open" })
map(
  "n",
  "go",
  [[:<C-u>put =repeat(nr2char(10),v:count)<Bar>execute "'[-1"<CR>]],
  { silent = true, desc = "Insert Line Below" }
)
map(
  "n",
  "gO",
  [[:<C-u>put!=repeat(nr2char(10),v:count)<Bar>execute "']+1"<CR>]],
  { silent = true, desc = "Insert Line Above" }
)

-- ([/]) namespace
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "[", group = "+prev" },
    { "]", group = "+next" },
  })
end
map("n", "[b", function()
  vim.cmd(vim.v.count1 .. "bprevious")
end, { desc = "Prev buffer" })
map("n", "]b", function()
  vim.cmd(vim.v.count1 .. "bnext")
end, { desc = "Next buffer" })
map("n", "[B", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "]B", "<cmd>blast<CR>", { desc = "Last buffer" })
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
map("n", "[l", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lprevious")
  vim.cmd.normal("zv")
end, { desc = "Prev ll entry" })
map("n", "]l", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lnext")
  vim.cmd.normal("zv")
end, { desc = "Next ll entry" })
map("n", "[L", "<cmd>lfirst<CR>", { desc = "First ll entry" })
map("n", "]L", "<cmd>llast<CR>", { desc = "Last ll entry" })
map("n", "[<C-l>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lpfile")
end, { desc = "Prev ll file" })
map("n", "]<C-l>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lnfile")
end, { desc = "Next ll file" })
map("n", "[q", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cprevious")
  vim.cmd.normal("zv")
end, { desc = "Prev qf entry" })
map("n", "]q", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cnext")
  vim.cmd.normal("zv")
end, { desc = "Next qf entry" })
map("n", "[Q", "<cmd>cfirst<CR>", { desc = "First qf entry" })
map("n", "]Q", "<cmd>clast<CR>", { desc = "Last qf entry" })
map("n", "[<C-q>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cpfile")
end, { desc = "Prev qf file" })
map("n", "]<C-q>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cnfile")
end, { desc = "Next qf file" })

-- Leader
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Buffer Delete" })
map("n", "<leader>X", "<cmd>bd!<CR>", { desc = "Buffer Wipeout" })

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
