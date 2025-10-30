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
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

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

local function find_file()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(buf_path, ":p:h")
  if dir == "" then
    dir = "."
  end
  local cmd = ":e " .. vim.fn.fnameescape(dir) .. "/"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", true)
end

-- Leader
map("n", "<leader>,", ":b ", { desc = "Find buffer" })
map("n", "<leader>.", find_file, { desc = "Find file" })

-- Leader + tab (tab)
map("n", "<leader><tab><tab>", "<cmd>tablast<cr>", { desc = "Last" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Delete" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First" })
map("n", "<leader><tab>l", "<cmd>tabs<cr>", { desc = "List" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next" })
map("n", "<leader><tab>N", "<cmd>tabnew<cr>", { desc = "New" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Only" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous" })

-- Leader + b (buffer)
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Last" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete" })
map("n", "<leader>bD", "<cmd>bd!<CR>", { desc = "Delete!" })
map("n", "<leader>bf", ":b ", { desc = "Find" })
map("n", "<leader>bk", ":bufdo bd!<CR>", { desc = "Killall" })
map("n", "<leader>bl", "<cmd>buffers<CR>", { desc = "List" })
map("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next" })
map("n", "<leader>bN", "<cmd>enew<CR>", { desc = "New" })
map("n", "<leader>bo", function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      buf ~= current_buf
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.fn.buflisted(buf) == 1
    then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Only" })
map("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous" })
map("n", "<leader>bs", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>bS", "<cmd>wall<CR>", { desc = "Save all" })
map("n", "<leader>bw", "<cmd>bw<CR>", { desc = "Wipeout" })
map("n", "<leader>bW", "<cmd>bw!<CR>", { desc = "Wipeout!" })
map("n", "<leader>by", "<cmd>%y+<CR>", { desc = "Yank" })

-- Leader + f (file)
map("n", "<leader>ff", find_file, { desc = "Find" })
map("n", "<leader>fd", "<cmd>DeleteFile<CR>", { desc = "Delete" })
map("n", "<leader>fD", "<cmd>DeleteFile!<CR>", { desc = "Delete!" })
map("n", "<leader>fr", "<cmd>RenameFile<CR>", { desc = "Rename" })
map("n", "<leader>fy", "<cmd>YankFilePath<CR>", { desc = "Yank path" })

-- Leader + u (ui)
map("n", "<leader>ui", ui.set_indent, { desc = "Set indent" })
map("n", "<leader>uc", ui.toggle_codelens, { desc = "Toggle codelens (buf)" })
map("n", "<leader>uC", ui.toggle_conceal, { desc = "Toggle conceal" })
map("n", "<leader>ud", function()
  ui.toggle_diagnostics(0)
end, { desc = "Toggle diagnostics (buf)" })
map("n", "<leader>uD", ui.toggle_diagnostics, { desc = "Toggle diagnostics (all)" })
map("n", "<leader>uf", ui.toggle_foldcolumn, { desc = "Toggle foldcolumn" })
map("n", "<leader>ui", ui.toggle_inlay_hints, { desc = "Toggle inlay hints (buf)" })
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

-- Leader + q (quit/session)
map("n", "<leader>qq", "<cmd>qall<CR>", { desc = "Quit" })
map("n", "<leader>qQ", "<cmd>qall!<CR>", { desc = "Quit!" })

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
vim.cmd("cnoremap <expr> %% getcwd()")
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
