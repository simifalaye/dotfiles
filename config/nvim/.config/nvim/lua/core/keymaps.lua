local m = require("utils.map")
local lib = require("utils.lib")

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

-- Unimpaired
m.nnoremap("[b", function()
  vim.cmd(vim.v.count1 .. "bprevious")
end, "Prev buffer")
m.nnoremap("]b", function()
  vim.cmd(vim.v.count1 .. "bnext")
end, "Next buffer")
m.nnoremap("[B", "<cmd>bfirst<CR>", "First buffer")
m.nnoremap("]B", "<cmd>blast<CR>", "Last buffer")
m.nnoremap("[l", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lprevious")
  vim.cmd.normal("zv")
end, "Prev ll entry")
m.nnoremap("]l", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lnext")
  vim.cmd.normal("zv")
end, "Next ll entry")
m.nnoremap("[L", "<cmd>lfirst<CR>", "First ll entry")
m.nnoremap("]L", "<cmd>llast<CR>", "Last ll entry")
m.nnoremap("[<C-l>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lpfile")
end, "Last ll entry previous file")
m.nnoremap("]<C-l>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lnfile")
end, "First ll entry next file")
m.nnoremap("[q", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cprevious")
  vim.cmd.normal("zv")
end, "Prev qf entry")
m.nnoremap("]q", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cnext")
  vim.cmd.normal("zv")
end, "Next qf entry")
m.nnoremap("[Q", "<cmd>cfirst<CR>", "First qf entry")
m.nnoremap("]Q", "<cmd>clast<CR>", "Last qf entry")
m.nnoremap("[<C-q>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cpfile")
end, "Last qf entry previous file")
m.nnoremap("]<C-q>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cnfile")
end, "First qf entry next file")
m.nnoremap("[<space>", function()
  vim.cmd("put! =repeat(nr2char(10), v:count1)|silent ']+")
end, "Add blank line above")
m.nnoremap("]<space>", function()
  vim.cmd("put =repeat(nr2char(10), v:count1)|silent '[-")
end, "Add blank line below")
m.nnoremap("[e", function()
  local count = vim.v.count1
  vim.cmd("silent! move --" .. count)
  vim.cmd.normal("==")
end, "Exchange above")
m.nnoremap("]e", function()
  local count = vim.v.count1
  vim.cmd("silent! move +" .. count)
  vim.cmd.normal("==")
end, "Exchange below")
m.nnoremap("[ob", function ()
  vim.o.background = "light"
  lib.ui_notify("Enabled background")
end, "Background")
m.nnoremap("]ob", function ()
  vim.o.background = "dark"
  lib.ui_notify("Disabled background")
end, "Background")
m.nnoremap("yob", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
    lib.ui_notify("Enabled background")
  else
    vim.o.background = "dark"
    lib.ui_notify("Disabled background")
  end
end, "Background")
m.nnoremap("[oc", function ()
  vim.o.cursorline = true
  lib.ui_notify("Enabled cursorline")
end, "Cursorline")
m.nnoremap("]oc", function ()
  vim.o.cursorline = false
  lib.ui_notify("Disabled cursorline")
end, "Cursorline")
m.nnoremap("yoc", function()
  if vim.o.cursorline then
    vim.o.cursorline = false
    lib.ui_notify("Disabled cursorline")
  else
    vim.o.cursorline = true
    lib.ui_notify("Enabled cursorline")
  end
end, "Cursorline")
 m.nnoremap("[od", function ()
  vim.g.user_diagnostics_mode = 3
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.ui_notify("Enabled diagnostics")
end, "Diagnostics")
m.nnoremap("]od", function ()
  vim.g.user_diagnostics_mode = 0
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.ui_notify("Disabled diagnostics")
end, "Diagnostics")
m.nnoremap("yod", function()
  vim.g.user_diagnostics_mode = (vim.g.user_diagnostics_mode - 1) % 4
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  if vim.g.user_diagnostics_mode == 0 then
    lib.ui_notify("diagnostics off")
  elseif vim.g.user_diagnostics_mode == 1 then
    lib.ui_notify("only status diagnostics")
  elseif vim.g.user_diagnostics_mode == 2 then
    lib.ui_notify("virtual text off")
  else
    lib.ui_notify("all diagnostics on")
  end
end, "Diagnostics")
m.nnoremap("[oh", function()
  vim.o.hlsearch = true
  lib.ui_notify("Enabled hlsearch")
end, "Hlsearch")
m.nnoremap("]oh", function()
  vim.o.hlsearch = false
  lib.ui_notify("Disabled hlsearch")
end, "Hlsearch")
m.nnoremap("yoh", function()
  if vim.o.hlsearch then
    vim.o.hlsearch = false
    lib.ui_notify("Disabled hlsearch")
  else
    vim.o.hlsearch = true
    lib.ui_notify("Enabled hlsearch")
  end
end, "Hlsearch")
m.nnoremap("[on", function()
  vim.o.number = true
  lib.ui_notify("Enabled number")
end, "Number")
m.nnoremap("]on", function()
  vim.o.number = false
  lib.ui_notify("Disabled number")
end, "Number")
m.nnoremap("yon", function()
  if vim.o.number then
    vim.o.number = false
    lib.ui_notify("Disabled number")
  else
    vim.o.number = true
    lib.ui_notify("Enabled number")
  end
end, "Number")
m.nnoremap("[oN", function()
  vim.g.user_notifications_enabled = true
  lib.ui_notify("Enabled notifications")
end, "Notifications")
m.nnoremap("]oN", function()
  vim.g.user_notifications_enabled = false
  lib.ui_notify("Disabled notifications")
end, "Notifications")
m.nnoremap("yoN", function()
  if vim.g.user_notifications_enabled then
    vim.g.user_notifications_enabled = false
    lib.ui_notify("Disabled notifications")
  else
    vim.g.user_notifications_enabled = true
    lib.ui_notify("Enabled notifications")
  end
end, "Notifications")
m.nnoremap("[or", function()
  vim.o.relativenumber = true
  lib.ui_notify("Enabled relative number")
end, "Relative number")
m.nnoremap("]or", function()
  vim.o.relativenumber = false
  lib.ui_notify("Disabled relative number")
end, "Relative number")
m.nnoremap("yor", function()
  if vim.o.relativenumber then
    vim.o.relativenumber = false
    lib.ui_notify("Disabled relative number")
  else
    vim.o.relativenumber = true
    lib.ui_notify("Enabled relative number")
  end
end, "Relative number")
m.nnoremap("[os", function()
  vim.o.spell = true
  lib.ui_notify("Enabled spell")
end, "Spell")
m.nnoremap("]os", function()
  vim.o.spell = false
  lib.ui_notify("Disabled spell")
end, "Spell")
m.nnoremap("yos", function()
  if vim.o.spell then
    vim.o.spell = false
    lib.ui_notify("Disabled spell")
  else
    vim.o.spell = true
    lib.ui_notify("Enabled spell")
  end
end, "Spell")
m.nnoremap("[oS", function()
  vim.o.signcolumn = true
  lib.ui_notify("Enabled signcolumn")
end, "Signcolumn")
m.nnoremap("]oS", function()
  vim.o.signcolumn = false
  lib.ui_notify("Disabled signcolumn")
end, "Signcolumn")
m.nnoremap("yoS", function()
  if vim.o.signcolumn then
    vim.o.signcolumn = false
    lib.ui_notify("Disabled signcolumn")
  else
    vim.o.signcolumn = true
    lib.ui_notify("Enabled signcolumn")
  end
end, "Signcolumn")
m.nnoremap("[ow", function()
  vim.o.wrap = true
  lib.ui_notify("Enabled wrap")
end, "Wrap")
m.nnoremap("]ow", function()
  vim.o.wrap = false
  lib.ui_notify("Disabled wrap")
end, "Wrap")
m.nnoremap("yow", function()
  if vim.o.wrap then
    vim.o.wrap = false
    lib.ui_notify("Disabled wrap")
  else
    vim.o.wrap = true
    lib.ui_notify("Enabled wrap")
  end
end, "Wrap")

-- (g) namespace
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
