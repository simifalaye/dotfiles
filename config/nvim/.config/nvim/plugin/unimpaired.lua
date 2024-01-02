-- Ensure we don't load the plugin twice
if vim.g.loaded_user_plugin_unimpaired then
  return
end
vim.g.loaded_user_plugin_unimpaired = true

local m = require("utils.map")
local lib = require("utils.lib")

local get_current_wininfo = function()
  return vim.fn.getwininfo(vim.fn.win_getid())[1]
end

local get_files = function(dir)
  local entries = vim.fn.split(vim.fn.glob(dir .. "/*"), "\n")
  local files = {}
  for _, entry in pairs(entries) do
    if vim.fn.isdirectory(entry) ~= 1 then
      table.insert(files, vim.fn.fnamemodify(entry, ":t"))
    end
  end
  if vim.tbl_isempty(files) then
    return
  else
    return files
  end
end

local file_by_offset = function(offset)
  local dir = vim.fn.expand("%:p:h")
  local files = get_files(dir)
  if not files then
    return
  end
  local current = vim.fn.expand("%:t")
  if current == "" then
    if offset < 0 then
      return dir .. "/" .. files[1]
    else
      return dir .. "/" .. files[#files]
    end
  else
    local index = vim.fn.index(files, current) + 1
    if index == 0 then
      return
    end
    index = index + offset
    if index < 1 then
      index = 1
    elseif index > #files then
      index = #files
    end
    return dir .. "/" .. files[index]
  end
end

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

m.group("[", "+prev")
m.group("]", "+next")
m.group("[o", "+enable")
m.group("]o", "+disable")
m.group("yo", "+toggle")

m.nnoremap("[<space>", function()
  vim.cmd("put! =repeat(nr2char(10), v:count1)|silent ']+")
end, "Add blank line above")
m.nnoremap("]<space>", function()
  vim.cmd("put =repeat(nr2char(10), v:count1)|silent '[-")
end, "Add blank line below")

m.nnoremap("[b", function()
  vim.cmd(vim.v.count1 .. "bprevious")
end, "Prev buffer")
m.nnoremap("]b", function()
  vim.cmd(vim.v.count1 .. "bnext")
end, "Next buffer")
m.nnoremap("[B", "<cmd>bfirst<CR>", "First buffer")
m.nnoremap("]B", "<cmd>blast<CR>", "Last buffer")

m.nnoremap("[ob", function()
  vim.o.background = "light"
  lib.ui_notify("Enabled background")
end, "Background")
m.nnoremap("]ob", function()
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

m.nnoremap("[oc", function()
  vim.o.cursorline = true
  lib.ui_notify("Enabled cursorline")
end, "Cursorline")
m.nnoremap("]oc", function()
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

m.nnoremap("[od", function()
  vim.g.user_diagnostics_mode = 3
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.ui_notify("Enabled diagnostics")
end, "Diagnostics")
m.nnoremap("]od", function()
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
m.vnoremap("[e", function()
  local count = vim.v.count1
  vim.cmd("silent! '<,'>move '<--" .. count)
  vim.cmd.normal("gv=")
end, "Exchange above")
m.vnoremap("]e", function()
  local count = vim.v.count1
  vim.cmd("silent! '<,'>move '>+" .. count)
  vim.cmd.normal("gv=")
end, "Exchange below")

m.nnoremap("[f", function()
  local wininfo = get_current_wininfo()
  if wininfo.loclist == 1 then
    vim.cmd("silent! lolder " .. vim.v.count1)
  elseif wininfo.quickfix == 1 then
    vim.cmd("silent! colder " .. vim.v.count1)
  else
    local file = file_by_offset(-vim.v.count1)
    if file then
      vim.cmd("edit " .. file)
    end
  end
end, "Prev file")
m.nnoremap("]f", function()
  local wininfo = get_current_wininfo()
  if wininfo.loclist == 1 then
    vim.cmd("silent! lnewer " .. vim.v.count1)
  elseif wininfo.quickfix == 1 then
    vim.cmd("silent! cnewer " .. vim.v.count1)
  else
    local file = file_by_offset(vim.v.count1)
    if file then
      vim.cmd("edit " .. file)
    end
  end
end, "Next file")

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

m.nnoremap("[ol", function()
  vim.o.list = true
  lib.ui_notify("Enabled list")
end, "List chars")
m.nnoremap("]ol", function()
  vim.o.list = false
  lib.ui_notify("Disabled list")
end, "List chars")
m.nnoremap("yol", function()
  if vim.o.list then
    vim.o.list = false
    lib.ui_notify("Disabled list")
  else
    vim.o.list = true
    lib.ui_notify("Enabled list")
  end
end, "List chars")

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

m.nnoremap("[ov", function()
  vim.o.virtualedit = "all"
  lib.ui_notify("Enabled virtualedit")
end, "Virtualedit")
m.nnoremap("]ov", function()
  vim.o.virtualedit = ""
  lib.ui_notify("Disabled virtualedit")
end, "Virtualedit")
m.nnoremap("yov", function()
  if vim.o.virtualedit then
    vim.o.virtualedit = false
    lib.ui_notify("Disabled virtualedit")
  else
    vim.o.virtualedit = true
    lib.ui_notify("Enabled virtualedit")
  end
end, "Virtualedit")

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
