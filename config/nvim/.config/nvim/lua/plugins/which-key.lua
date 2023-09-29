return {
  {
    "folke/which-key.nvim",
    event = "BufWinEnter",
    opts = {
      disable = { filetypes = { "TelescopePrompt" } },
      window = {
        border = "single", -- none, single, double, shadow
      },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      defaults = {
        ["]"] = { name = "+next", mode = {"n", "x"} },
        ["["] = { name = "+prev", mode = {"n", "x"} },
        ["g"] = { name = "+namespace", mode = {"n", "x"} },
        ["z"] = { name = "+namespace", mode = {"n", "x"} },
        ["<localleader>"] = { name = "+localleader", mode = {"n", "x"} },
        ["<leader>"] = { name = "+leader", mode = {"n", "x"} },
        ["<leader>f"] = { name = "+find", mode = {"n", "x"} },
        ["<leader>g"] = { name = "+git" },
        ["<leader>p"] = { name = "+plugin" },
        ["<leader>u"] = { name = "+ui" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
