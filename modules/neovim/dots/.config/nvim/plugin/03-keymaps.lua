local map = vim.keymap.set
local ui = require("utils.ui")

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
map("n", "<leader>ui", ui.set_indent, { desc = "Set indent" })
map("n", "<leader>uc", ui.toggle_codelens, { desc = "Toggle codelens (buf)" })
map("n", "<leader>uC", ui.toggle_conceal, { desc = "Toggle conceal" })
map("n", "<leader>ud", function()
  ui.toggle_diagnostics(0)
end, { desc = "Toggle diagnostics (buf)" })
map("n", "<leader>uD", ui.toggle_diagnostics, { desc = "Toggle diagnostics (all)" })
map("n", "<leader>uf", ui.toggle_foldcolumn, { desc = "Toggle foldcolumn" })
map("n", "<leader>ui", ui.toggle_inlay_hints, { desc = "Toggle inlay hints (buf)" })
map("n", "<leader>ul", ui.toggle_statusline, { desc = "Toggle statusline" })
map("n", "<leader>up", ui.toggle_paste, { desc = "Toggle paste mode" })
map(
  "n",
  "<leader>us",
  ui.toggle_semantic_tokens,
  { desc = "Toggle semantic tokens (buf)" }
)
map("n", "<leader>uS", ui.toggle_signcolumn, { desc = "Toggle sign column" })
map("n", "<leader>uw", ui.toggle_wrap, { desc = "Toggle wrap" })
map("n", "<leader>uz", ui.toggle_spell, { desc = "Toggle spell" })

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

-- Text Objects
map("x", "ie", [[gg0oG$]], { desc = "entire buffer" })
map(
  "o",
  "ie",
  [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]],
  { desc = "entire buffer" }
)
map("x", "al", "$o0", { desc = "line" })
map("o", "al", "<cmd>normal val<CR>", { desc = "line" })
map("x", "il", [[<Esc>^vg_]], { desc = "inner line" })
map("o", "il", [[<cmd>normal! ^vg_<CR>]], { desc = "inner line" })

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
