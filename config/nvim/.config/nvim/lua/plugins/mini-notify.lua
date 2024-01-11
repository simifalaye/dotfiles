return {
  {
    "rcarriga/nvim-notify",
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      level = vim.g.user_log_level
    }
  },
  -- {
  --   "echasnovski/mini.notify",
  --   version = false,
  --   init = function()
  --     vim.notify = require("mini.notify").make_notify()
  --   end,
  --   config = function()
  --     require("mini.notify").setup()
  --   end,
  -- },
}
