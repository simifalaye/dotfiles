return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "sindrets/diffview.nvim",
        opts = {},
      },
    },
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({ ["<leader>g"] = { name = "+git" } })
      end
    end,
    opts = {},
  },
}
