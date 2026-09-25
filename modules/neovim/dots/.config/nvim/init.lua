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

-- Enable clipboard
vim.schedule(function()
  if not vim.g.neovide and (vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1) then
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
  end
  vim.opt.clipboard = "unnamedplus"
end)

-- Configure Neovide GUI
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.3
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_theme = "auto"
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
