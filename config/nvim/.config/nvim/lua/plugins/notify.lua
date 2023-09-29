return {
  {
    "rcarriga/nvim-notify",
    init = function()
      require("utils").load_plugin_with_func("nvim-notify", vim, "notify")
    end,
    keys = {
      { "g>", "<cmd>Notifications<CR>", desc = "Show notifications" },
      {
        "g<",
        function()
          require("notify").dismiss({ pending = true, silent = true })
        end,
        desc = "Dismiss notifications",
      },
    },
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 175 })
        if not vim.g.user_notifications_enabled then
          vim.api.nvim_win_close(win, true)
        end
        if not package.loaded["nvim-treesitter"] then
          pcall(require, "nvim-treesitter")
        end
        vim.wo[win].conceallevel = 3
        local buf = vim.api.nvim_win_get_buf(win)
        if not pcall(vim.treesitter.start, buf, "markdown") then
          vim.bo[buf].syntax = "markdown"
        end
        vim.wo[win].spell = false
      end,
      render = "compact",
      stages = "static",
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}
