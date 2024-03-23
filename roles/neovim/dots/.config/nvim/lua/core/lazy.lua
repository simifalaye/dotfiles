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
      "catppuccin",
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
  change_detection = {
    notify = false,
  },
  lockfile = require("utils.fs").join_paths(vim.fn.stdpath("data"), "lazy-lock.json"),
})
