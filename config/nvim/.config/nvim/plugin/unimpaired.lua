-- Ensure we don't load the plugin twice
if vim.g.loaded_user_plugin_unimpaired then
  return
end
vim.g.loaded_user_plugin_unimpaired = true

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

local function opt2str(val)
  if type(val) == "string" then
    return val
  end
  return val and "on" or "off"
end

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

local lib = require("utils.lib")
local map = vim.keymap.set

vim.keymap.set("n", "[", "[", { desc = "+prev" })
vim.keymap.set("n", "]", "]", { desc = "+next" })
vim.keymap.set("n", "[o", "[o", { desc = "+enable" })
vim.keymap.set("n", "]o", "]o", { desc = "+disable" })
vim.keymap.set("n", "yo", "yo", { desc = "+toggle" })

map("n", "[<space>", function()
  vim.cmd("put! =repeat(nr2char(10), v:count1)|silent ']+")
end, { desc = "Add blank line above" })
map("n", "]<space>", function()
  vim.cmd("put =repeat(nr2char(10), v:count1)|silent '[-")
end, { desc = "Add blank line below" })

map("n", "[b", function()
  vim.cmd(vim.v.count1 .. "bprevious")
end, { desc = "Prev buffer" })
map("n", "]b", function()
  vim.cmd(vim.v.count1 .. "bnext")
end, { desc = "Next buffer" })
map("n", "[B", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "]B", "<cmd>blast<CR>", { desc = "Last buffer" })

map("n", "[ob", function()
  vim.o.background = "light"
  lib.notify("Background " .. vim.o.background)
end, { desc = "Background" })
map("n", "]ob", function()
  vim.o.background = "dark"
  lib.notify("Background " .. vim.o.background)
end, { desc = "Background" })
map("n", "yob", function()
  vim.o.background = vim.o.background == "light" and "dark" or "light"
  lib.notify("Background " .. vim.o.background)
end, { desc = "Background" })

map("n", "[oc", function()
  vim.o.cursorline = true
  lib.notify("Cursorline " .. opt2str(vim.o.cursorline))
end, { desc = "Cursorline" })
map("n", "]oc", function()
  vim.o.cursorline = false
  lib.notify("Cursorline " .. opt2str(vim.o.cursorline))
end, { desc = "Cursorline" })
map("n", "yoc", function()
  vim.o.cursorline = not vim.o.cursorline
  lib.notify("Cursorline " .. opt2str(vim.o.cursorline))
end, { desc = "Cursorline" })

map("n", "[od", function()
  vim.g.user_diagnostics_mode = 3
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.notify("Diagnostic level " .. vim.g.user_diagnostics_mode)
end, { desc = "Diagnostics" })
map("n", "]od", function()
  vim.g.user_diagnostics_mode = 0
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.notify("Diagnostic level " .. vim.g.user_diagnostics_mode)
end, { desc = "Diagnostics" })
map("n", "yod", function()
  vim.g.user_diagnostics_mode = (vim.g.user_diagnostics_mode - 1) % 4
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
  lib.notify("Diagnostic level " .. vim.g.user_diagnostics_mode)
end, { desc = "Diagnostics" })

map("n", "[e", function()
  local count = vim.v.count1
  vim.cmd("silent! move --" .. count)
  vim.cmd.normal("==")
end, { desc = "Exchange above" })
map("n", "]e", function()
  local count = vim.v.count1
  vim.cmd("silent! move +" .. count)
  vim.cmd.normal("==")
end, { desc = "Exchange below" })
map("v", "[e", function()
  local count = vim.v.count1
  vim.cmd("silent! '<,'>move '<--" .. count)
  vim.cmd.normal("gv=")
end, { desc = "Exchange above" })
map("v", "]e", function()
  local count = vim.v.count1
  vim.cmd("silent! '<,'>move '>+" .. count)
  vim.cmd.normal("gv=")
end, { desc = "Exchange below" })

map("n", "[f", function()
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
end, { desc = "Prev file" })
map("n", "]f", function()
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
end, { desc = "Next file" })

map("n", "[oh", function()
  vim.o.hlsearch = true
  lib.notify("Hlsearch " .. opt2str(vim.o.hlsearch))
end, { desc = "Hlsearch" })
map("n", "]oh", function()
  vim.o.hlsearch = false
  lib.notify("Hlsearch " .. opt2str(vim.o.hlsearch))
end, { desc = "Hlsearch" })
map("n", "yoh", function()
  vim.o.hlsearch = not vim.o.hlsearch
  lib.notify("Hlsearch " .. opt2str(vim.o.hlsearch))
end, { desc = "Hlsearch" })

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
end, { desc = "Last ll entry previous file" })
map("n", "]<C-l>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "lnfile")
end, { desc = "First ll entry next file" })

map("n", "[ol", function()
  vim.o.list = true
  lib.notify("Listchars " .. opt2str(vim.o.list))
end, { desc = "List chars" })
map("n", "]ol", function()
  vim.o.list = false
  lib.notify("Listchars " .. opt2str(vim.o.list))
end, { desc = "List chars" })
map("n", "yol", function()
  vim.o.list = not vim.o.list
  lib.notify("Listchars " .. opt2str(vim.o.list))
end, { desc = "List chars" })

map("n", "[on", function()
  vim.o.number = true
  lib.notify("Number " .. opt2str(vim.o.number))
end, { desc = "Number" })
map("n", "]on", function()
  vim.o.number = false
  lib.notify("Number " .. opt2str(vim.o.number))
end, { desc = "Number" })
map("n", "yon", function()
  vim.o.number = not vim.o.number
  lib.notify("Number " .. opt2str(vim.o.number))
end, { desc = "Number" })

map("n", "[oN", function()
  vim.g.user_notifications_enabled = true
  lib.notify("Notifications " .. opt2str(vim.g.user_notifications_enabled))
end, { desc = "Notifications" })
map("n", "]oN", function()
  lib.notify("Notifications " .. opt2str(vim.g.user_notifications_enabled))
  vim.g.user_notifications_enabled = false
end, { desc = "Notifications" })
map("n", "yoN", function()
  if vim.g.user_notifications_enabled then
    lib.notify("Notifications " .. opt2str(false))
    vim.g.user_notifications_enabled = false
  else
    vim.g.user_notifications_enabled = true
    lib.notify("Notifications " .. opt2str(true))
  end
end, { desc = "Notifications" })

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
end, { desc = "Last qf entry previous file" })
map("n", "]<C-q>", function()
  vim.cmd("silent! " .. vim.v.count1 .. "cnfile")
end, { desc = "First qf entry next file" })

map("n", "[or", function()
  vim.o.relativenumber = true
  lib.notify("Relative number " .. opt2str(vim.o.relativenumber))
end, { desc = "Relative number" })
map("n", "]or", function()
  vim.o.relativenumber = false
  lib.notify("Relative number " .. opt2str(vim.o.relativenumber))
end, { desc = "Relative number" })
map("n", "yor", function()
  vim.o.relativenumber = not vim.o.relativenumber
  lib.notify("Relative number " .. opt2str(vim.o.relativenumber))
end, { desc = "Relative number" })

map("n", "[os", function()
  vim.o.spell = true
  lib.notify("Spell " .. opt2str(vim.o.spell))
end, { desc = "Spell" })
map("n", "]os", function()
  vim.o.spell = false
  lib.notify("Spell " .. opt2str(vim.o.spell))
end, { desc = "Spell" })
map("n", "yos", function()
  vim.o.spell = not vim.o.spell
  lib.notify("Spell " .. opt2str(vim.o.spell))
end, { desc = "Spell" })

map("n", "[ov", function()
  vim.o.virtualedit = "all"
  lib.notify("Virtualedit " .. vim.o.virtualedit)
end, { desc = "Virtualedit" })
map("n", "]ov", function()
  vim.o.virtualedit = ""
  lib.notify("Virtualedit " .. vim.o.virtualedit)
end, { desc = "Virtualedit" })
map("n", "yov", function()
  if vim.o.virtualedit then
    vim.o.virtualedit = false
    lib.notify("Virtualedit on")
  else
    vim.o.virtualedit = true
    lib.notify("Virtualedit off")
  end
end, { desc = "Virtualedit" })

map("n", "[ow", function()
  vim.o.wrap = true
  lib.notify("Wrap " .. opt2str(vim.o.wrap))
end, { desc = "Wrap" })
map("n", "]ow", function()
  vim.o.wrap = false
  lib.notify("Wrap " .. opt2str(vim.o.wrap))
end, { desc = "Wrap" })
map("n", "yow", function()
  vim.o.wrap = not vim.o.wrap
  lib.notify("Wrap " .. opt2str(vim.o.wrap))
end, { desc = "Wrap" })
