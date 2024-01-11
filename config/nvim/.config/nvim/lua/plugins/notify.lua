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
}

