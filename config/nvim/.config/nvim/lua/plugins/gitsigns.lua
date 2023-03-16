return {
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    cmd = { "Gitsigns" },
    keys = {
      {
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        desc = "In hunk",
      },
      {
        "]h",
        function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Next hunk",
        expr = true,
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Prev hunk",
        expr = true,
      },
      {
        "<leader>hb",
        "<cmd>Gitsigns blame_line full=true<CR>",
        desc = "Blame line",
      },
      { "<leader>hd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff" },
      { "<leader>hD", "<cmd>Gitsigns diffthis ~<CR>", desc = "Diff HEAD" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buff" },
      { "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage Buff" },
      {
        "<leader>ht",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "Toggle blame",
      },
      {
        "<leader>hu",
        "<cmd>Gitsigns undo_stage_hunk<CR>",
        desc = "Undo Stage",
      },
    },
    init = function()
      local m = require("utils.map")
      m.group("<leader>h", "+hunk", { "n", "v" })
    end,
    opts = {},
  },
}
