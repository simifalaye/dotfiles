--[[

Neovim inint file
Nvim version: 0.12.0+
Maintainer: simifalaye

--]]

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

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

_G.exec_cache = { later = {} }

_G.exec_now = function(func, init_trace)
  local ok, err = xpcall(func, function(e)
    return debug.traceback(e .. "\n", 2)
  end)
  if ok then
    return true
  end
  init_trace = init_trace == nil and ""
    or ("\n\nTraceback of `_G.exec_now` call:\n" .. init_trace)
  vim.notify("Error during safe execution: " .. err .. init_trace, vim.log.levels.WARN)
  return false
end

_G.exec_later = function(func)
  local function later()
    local timer = assert(vim.loop.new_timer())
    local f
    f = vim.schedule_wrap(function()
      local cb = _G.exec_cache.later[1]
      if cb == nil then
        if not timer:is_closing() then
          timer:close()
        end
        return
      end

      table.remove(_G.exec_cache.later, 1)
      _G.exec_now(cb.f, cb.trace)
      timer:start(1, 0, f)
    end)
    -- Space out "later" executions to be sure that they don't block anything
    timer:start(1, 0, f)
  end

  -- Compute traceback before delaying execution to provide more info
  local trace = debug.traceback("", 2)
  if #_G.exec_cache.later == 0 then
    vim.schedule(later)
  end
  table.insert(_G.exec_cache.later, { f = func, trace = trace })
end

--- Run function now if neovim is started with arguments or schedule
---@param f function
_G.exec_now_if_args = function(f)
  if vim.fn.argc(-1) > 0 then
    _G.exec_now(f)
  else
    _G.exec_later(f)
  end
end

-- Define custom autocommand group
_G.custom_config_augroup = vim.api.nvim_create_augroup("user.config", {})

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

local default_vim_notify = vim.notify
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
  level = level or vim.log.levels.INFO
  if level < vim.g.user_log_level then
    return
  end
  return default_vim_notify(msg, level, opts)
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
    end),
  })
  vim.opt.guifont = "JetBrainsMono Nerd Font:h14"

  local font_size_factor = 1.1
  local change_font_size = function(factor)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
  end
  vim.keymap.set("n", "<C-=>", function()
    change_font_size(font_size_factor)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_font_size(1 / font_size_factor)
  end)
end

-- Enable ui2
require("vim._core.ui2").enable({ enable = true, msg = { targets = "msg" } })
