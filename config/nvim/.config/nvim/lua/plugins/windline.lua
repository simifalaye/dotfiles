return {
  {
    "windwp/windline.nvim",
    event = "VeryLazy",
    config = function()
      local windline = require("windline")
      local explorer = {
        filetypes = { "fern", "NvimTree", "netrw", "neo-tree" },
        active = {
          { "  ", { "white", "black" } },
        },
        --- show active components when the window is inactive
        always_active = true,
        --- It will display a last window statusline even that window should inactive
        show_last_status = true,
      }

      windline.setup({
        statuslines = {
          require('wlsample.vscode'),
          explorer,
        },
      })
    end,
  },
}
