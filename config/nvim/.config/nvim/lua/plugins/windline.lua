return {
  {
    "windwp/windline.nvim",
    event = "VeryLazy",
    init = function()
      require("utils.command").augroup("user_statusline_search_count", {
        {
          desc = "hello",
          event = { "CursorMoved", "CursorMovedI" },
          pattern = "*",
          -- Function to update the search count
          command = function()
            if vim.v.hlsearch == 1 then
              vim.fn.searchcount({ recompute = 1, maxcount = 0, timeout = 100 })
              vim.api.nvim_command("redrawstatus")
            end
          end,
        },
      })
    end,
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
          require("wlsample.vscode"),
          explorer,
        },
      })
    end,
  },
}
