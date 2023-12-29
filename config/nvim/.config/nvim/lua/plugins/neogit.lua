return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" } },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function ()
      require("utils.map").group("<leader>g", "+git")
    end,
    config = function()
      require("neogit").setup({})
    end,
  },
}
