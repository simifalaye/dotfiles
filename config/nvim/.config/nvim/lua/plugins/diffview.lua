return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    keys = { { "<leader>d", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    config = true,
  },
}
