return {
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    cmd = { "Gitsigns" },
    keys = {
      {
        "ig",
        ":<C-U>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        desc = "In hunk",
      },
      { "]g", "<cmd>Gitsigns next_hunk<CR>", desc = "Next git hunk" },
      { "[g", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev git hunk" },
      { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff" },
      { "<leader>gD", "<cmd>Gitsigns diffthis ~<CR>", desc = "Diff HEAD" },
      {
        "<leader>gl",
        "<cmd>Gitsigns blame_line full=true<CR>",
        desc = "Blame line",
      },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buff" },
      {
        "<leader>gt",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "Toggle blame",
      },
      {
        "<leader>gu",
        "<cmd>Gitsigns undo_stage_hunk<CR>",
        desc = "Undo htage",
      },
      { "<leader>gw", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
      { "<leader>gW", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage huff" },
    },
    opts = {},
  },
}
