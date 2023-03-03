--[[

Neovim inint file
Nvim version: 0.8.0+
Maintainer: simifalaye

--]]

-- Map leader (MUST come before lazy plugin manager)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load globals
require("globals")

-- Load core modules
require("core.options")
require("core.commands")
require("core.autocommands")
require("core.keymaps")

-- Install lazy plugin manager if not installed and add to rtp
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy and configure
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = {
    colorscheme = {
      (function()
        if vim.env.BASE16_THEME ~= nil and vim.env.BASE16_THEME ~= "" then
          return "base16-" .. vim.env.BASE16_THEME
        end
        return "habamax"
      end)(),
    },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
