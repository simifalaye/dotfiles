return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" } },
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      {
        "akinsho/git-conflict.nvim",
        lazy = false,
        version = "*",
        opts = {
          default_mappings = {
            ours = "co",
            theirs = "ct",
            none = "c0",
            both = "cb",
            next = "]x",
            prev = "[x",
          },
        },
        config = true,
      },
    },
    config = function ()
      require("neogit").setup({})
    end
  },
}
