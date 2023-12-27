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
-- NOTE: Map leader must be set before this point
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = {
    colorscheme = {
      "catppuccin-mocha",
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
      disabled_plugins = {},
    },
  },
  lockfile = require("utils.fs").join_paths(vim.fn.stdpath("data"), "lazy-lock.json"),
})
