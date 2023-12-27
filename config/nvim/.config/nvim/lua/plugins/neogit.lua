return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" } },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("neogit").setup({})
    end,
  },
}
