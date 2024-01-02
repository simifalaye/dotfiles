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
      (function()
        if vim.env.BASE16_THEME ~= nil and vim.env.BASE16_THEME ~= "" then
          return "base16-" .. vim.env.BASE16_THEME
        end
        return "base16-default-dark"
      end)(),
      "habamax",
    },
  },
  ui = {
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = " ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "!",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  rtp = {
    disabled_plugins = {
      "2html_plugin",
      "gzip",
      "matchit",
      "tar",
      "tarPlugin",
      "tutor_mode_plugin",
      "vimball",
      "vimballPlugin",
      "zip",
      "zipPlugin",
    },
  },
  change_detection = {
    notify = false,
  },
  lockfile = require("utils.fs").join_paths(vim.fn.stdpath("data"), "lazy-lock.json"),
})
