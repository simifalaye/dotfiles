return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      window = {
        border = "single",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Setup default groups
      wk.register({
        ["<leader>p"] = { name = "+plugins" },
      })
    end,
  },
}
