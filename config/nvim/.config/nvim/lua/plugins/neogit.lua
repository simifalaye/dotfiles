return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = {
      { "<leader>g", "<leader>g", desc = "+git" },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {"sindrets/diffview.nvim"},
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({})
    end,
  },
}
