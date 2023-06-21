return {
  {
    "rcarriga/nvim-notify",
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 1000 })
        -- close notification immediately if notifications disabled
        if not vim.g.user_notifications_enabled then
          vim.api.nvim_win_close(win, true)
        end
      end,
    },
    init = function()
      -- Load plugin when vim.notify is called
      local old_func = vim.notify
      vim.notify = function(...)
        vim.notify = old_func
        require("notify")
        vim.notify(...)
      end
    end,
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}
