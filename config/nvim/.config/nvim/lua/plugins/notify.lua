return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    keys = {
      {
        "g[",
        function()
          local telescope = require("utils.prequire")("telescope")
          if not telescope then
            require("notify").history()
            return
          end
          if telescope.extensions.notify == nil then
            telescope.load_extension("notify")
          end
          telescope.extensions.notify.notify()
        end,
        desc = "Show notifications",
      },
      {
        "g]",
        function()
          require("notify").dismiss({ pending = true, silent = true })
        end,
        desc = "Dismiss notifications",
      },
    },
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      -- Set lowest log level as we will control log level through
      -- utils.lib.notify()
      level = vim.log.levels.TRACE,
      render = "compact",
    },
  },
}

