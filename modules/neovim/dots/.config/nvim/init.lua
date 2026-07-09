--[[

Neovim inint file
Nvim version: 0.11.0+
Maintainer: simifalaye

--]]

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

--
-- Globals
--

--- Inspect the contents of an object very quickly
--- ex. P({1,2,3})
--- @vararg any
--- @return any
_G.dd = function(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

--- Run function now if neovim is started with arguments or schedule
---@param f function
_G.now_if_args = function(f)
  if vim.fn.argc(-1) > 0 then
    f()
  else
    vim.schedule(f)
  end
end

--- Custom `vim.pack.add()` hook helper
---@param plugin_name string
---@param kinds string[]
---@param callback function
---@param desc string
_G.on_packchanged = function(plugin_name, kinds, callback, desc)
  if vim.fn.has("nvim-0.12") == 0 then
    return
  end
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev)
  end
  vim.api.nvim_create_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

--- Lazy require a module so it is only called on use
_G.lazy_require = function(module_name)
  return setmetatable({}, {
    __index = function(_, key)
      return function(...)
        local module = require(module_name)
        return module[key](...)
      end
    end,
  })
end

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Process the log level environment variable if set
if vim.env.LOG_LEVEL and type(vim.env.LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    vim.g.user_log_level = lvl
  end
else
  vim.g.user_log_level = vim.log.levels.INFO
end

-- Disable unused builtin plugins
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true
vim.g.loaded_netrwFileHandlers = true
vim.g.loaded_gzip = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true
vim.g.loaded_tohtml = true
vim.g.loaded_2html_plugin = true

-- User config
vim.g.user_lsp_codelens_disable = true

--
-- Options
--

-- General
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:25,hor:6"
vim.opt.switchbuf = "usetab"
vim.opt.undofile = true
vim.opt.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.opt.exrc = true
vim.opt.swapfile = false -- TODO: Evaluate
vim.opt.confirm = true

-- UI
vim.opt.breakindent = true
vim.opt.breakindentopt = "list:-1"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "screenline,number"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
vim.opt.fillchars = {
  fold = "·",
  foldopen = " ",
  foldclose = ">",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 1
vim.opt.pumheight = 16
vim.opt.pummaxwidth = 100
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.shortmess = "CFOWaco"
vim.opt.splitkeep = "screen"
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 16
require("vim._core.ui2").enable({ enable = true, msg = { target = "msg" } })

-- Editing
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.formatoptions = "rqnl1j"
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.virtualedit = "block"
-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.completeopt = "menu,menuone,fuzzy,popup,noselect"
vim.opt.complete = ".,w,b,kspell"
vim.opt.wildmode = "noselect:lastused"
vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = ":",
  callback = function()
    vim.fn.wildtrigger()
  end,
})

-- Spelling
vim.opt.spelllang = "en"
vim.opt.spelloptions = "camel"

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
vim.g.markdown_folding = 1
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.foldtext = ""
end

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append({
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
})

-- Add filetypes
vim.filetype.add({
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})

-- Configure Neovide GUI
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.3
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_theme = "auto"
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    desc = "Lazy load clipboard",
    callback = vim.schedule_wrap(function()
      vim.opt.clipboard = "unnamedplus"
    end)
  })
  vim.opt.guifont = "JetBrainsMono Nerd Font:h14"

  local font_size_factor = 1.1
  local change_font_size = function(factor)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
  end
  vim.keymap.set('n', '<C-=>', function()
    change_font_size(font_size_factor)
  end)
  vim.keymap.set('n', '<C-->', function()
    change_font_size(1 / font_size_factor)
  end)
else
  -- Explicitly set clipboard
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    desc = "Lazy load clipboard",
    callback = vim.schedule_wrap(function()
      if vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
          copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
          },
          paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
          },
        }
      elseif vim.fn.has("unix") == 1 then
        if vim.fn.executable("xclip") == 1 then
          vim.g.clipboard = {
            copy = {
              ["+"] = "xclip -selection clipboard",
              ["*"] = "xclip -selection clipboard",
            },
            paste = {
              ["+"] = "xclip -selection clipboard -o",
              ["*"] = "xclip -selection clipboard -o",
            },
          }
        elseif vim.fn.executable("xsel") == 1 then
          vim.g.clipboard = {
            copy = {
              ["+"] = "xsel --clipboard --input",
              ["*"] = "xsel --clipboard --input",
            },
            paste = {
              ["+"] = "xsel --clipboard --output",
              ["*"] = "xsel --clipboard --output",
            },
          }
        end
      end
      vim.opt.clipboard = "unnamedplus"
    end),
  })
end

---

-- vim.pack.add({
--   {
--     src = "https://github.com/simifalaye/msgarea.nvim.git",
--   },
-- })
--
-- vim.pack.add({ "https://github.com/edisj/msgarea.nvim" })
-- vim.g.msgarea_max_height = 15
-- -- vim.g.msgarea_max_height = 0.4    OR fractional heights 0-1 are percentage of editor height
-- vim.g.msgarea_min_height = 3
-- -- vim.g.msgarea_min_height = 0.1    same as above
--
-- -- if you use blink.cmp and want to have cmdline completions render in msgarea
-- -- require("msgarea.blink_integration").enable()
-- -- require("msgarea.blink_integration").disable()  -- can be disabled at any time
--
-- -- set a keymap to collapse the msgarea
-- vim.keymap.set("n", "<M-n>", function()
--   require("msgarea").close_all()
-- end)
-- -- two other api functions are available:
-- -- require("msgarea").hide()   hide (but do not close) all windows and collapse cmdheight
-- -- require("msgarea").show()   reveal all windows and expand cmdheight
--
-- -- -- assuming you already called require("vim._core.ui2").enable({ ... }) in your config
-- -- local targets = require("vim._core.ui2").cfg.msg.targets
-- -- for _, target in ipairs({
-- --   "wmsg",
-- --   "emsg",
-- --   "typed_cmd",
-- --   "list_cmd",
-- --   "lua_error",
-- --   "lua_print",
-- --   "echoerr",
-- -- }) do
-- --   ---@diagnostic disable-next-line: assign-type-mismatch
-- --   targets[target] = "msgarea"
-- -- end
--
-- -- TODO: Revisit
-- local function set_cmdheight(height)
--   if height ~= 0 then
--     vim.api.nvim_set_option_value("cmdheight", height, { scope = "global" })
--   else
--     vim.api.nvim_set_option_value("cmdheight", 0, { scope = "global" })
--   end
-- end
--
-- local function redirect_pum_to_msgarea()
--   local original_cmdheight = vim.o.cmdheight
--   local ns = vim.api.nvim_create_namespace("my_fancy_pum")
--   local keepheight = 1
--   local target_buf = nil
--   local target_win = nil
--   local target_mark
--   vim.ui_attach(ns, { ext_popupmenu = true }, function(event, ...)
--     if event == "popupmenu_show" then
--       local is_cmdline = vim.fn.getcmdtype() ~= ""
--       local items, _, _, _, _ = ...
--       local lines = {}
--       for i, item in ipairs(items) do
--         lines[i] = item[1]
--       end
--       if target_buf == nil or not vim.api.nvim_buf_is_valid(target_buf) then
--         target_buf = vim.api.nvim_create_buf(false, true)
--       end
--       vim.api.nvim_buf_set_lines(target_buf, 0, -1, false, lines)
--
--       local win_opts = {}
--       if is_cmdline then
--         local h = math.min(#lines, 10)
--         h = math.max(keepheight, h)
--         keepheight = h
--         set_cmdheight(h + 1)
--         win_opts = {
--           relative = "editor",
--           width = vim.o.columns,
--           hide = false,
--           height = keepheight,
--           row = vim.o.lines - 1,
--           col = 0,
--           style = "minimal",
--           zindex = 999,
--         }
--       else
--         win_opts = {
--           "cursor",
--           row = 1,
--           col = 0,
--           width = 30,
--           height = math.min(#items, 10),
--           style = "minimal",
--           border = "single",
--         }
--       end
--       if target_win and vim.api.nvim_win_is_valid(target_win) then
--         vim.api.nvim_win_set_config(target_win, win_opts)
--       else
--         target_win = vim.api.nvim_open_win(target_buf, false, win_opts)
--       end
--       vim.api.nvim_win_call(target_win, function()
--         vim.api.nvim_set_option_value("filetype", "", { scope = "local" })
--         vim.api.nvim_set_option_value("eventignorewin", "all", { scope = "local" })
--         vim.api.nvim_set_option_value("wrap", false, { scope = "local" })
--         vim.api.nvim_set_option_value("linebreak", false, { scope = "local" })
--         vim.api.nvim_set_option_value("swapfile", false, { scope = "local" })
--         vim.api.nvim_set_option_value("modifiable", true, { scope = "local" })
--         vim.api.nvim_set_option_value("bufhidden", "hide", { scope = "local" })
--         vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local" })
--         vim.api.nvim_set_option_value(
--           "winhighlight",
--           "Normal:Normal",
--           { scope = "local" }
--         )
--       end)
--     elseif event == "popupmenu_select" then
--       local selected = ...
--       if selected >= 0 and target_buf then
--         if target_mark then
--           vim.api.nvim_buf_del_extmark(target_buf, ns, target_mark)
--         end
--         target_mark = vim.api.nvim_buf_set_extmark(target_buf, ns, selected, 0, {
--           line_hl_group = "Visual", -- or PmenuSel, CursorLine, etc.
--         })
--       end
--     elseif event == "popupmenu_hide" then
--       local is_cmdline = vim.fn.getcmdtype() ~= ""
--       if target_win and vim.api.nvim_win_is_valid(target_win) then
--         vim.api.nvim_win_close(target_win, true)
--         target_win = nil
--       end
--       if target_buf and target_mark then
--         vim.api.nvim_buf_del_extmark(target_buf, ns, target_mark)
--       end
--       if is_cmdline then
--         set_cmdheight(original_cmdheight)
--       end
--       keepheight = 1
--     end
--   end)
-- end
--
-- redirect_pum_to_msgarea()
