return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      window = {
        border = "single",
      },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["yo"] = { name = "+toggle" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["]o"] = { name = "+enable" },
        ["[o"] = { name = "+disable" },
        ["<leader>p"] = { name = "+plugins" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
