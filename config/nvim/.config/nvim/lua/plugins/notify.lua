return {
  {
    "rcarriga/nvim-notify",
    keys = {
      { "g>", "<cmd>Notifications<CR>", desc = "Show Notifications" },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(...)
        require("lazy").load({ plugins = { "nvim-notify" } })
        return vim.notify(...)
      end
    end,
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 1000 })
        -- close notification immediately if notifications disabled
        if not vim.g.user_notifications_enabled then
          vim.api.nvim_win_close(win, true)
        end
      end,
      -- Manage log levels ourselves
      level = 0,
    },
    config = function(_, opts)
      local m = require("utils.map")
      -- Load plugin
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
      m.nnoremap("g<", function()
        notify.dismiss({ pending = true })
      end, "Dismiss Notifications")
      -- Load telescope extension if available
      local telescope = require("utils.prequire")("telescope")
      if telescope then
        telescope.load_extension("notify")
        m.nnoremap("<leader>fn", "<cmd>Telescope notify<CR>", "Notifications")
      end
    end,
  },
}
