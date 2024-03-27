return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = { spelling = true },
      window = {
        border = "single",
      },
      layout = {
        align = "left",
      },
      disable = { filetypes = { "TelescopePrompt" } },
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
