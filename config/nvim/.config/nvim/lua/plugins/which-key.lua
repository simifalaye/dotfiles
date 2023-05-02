return {
  {
    "folke/which-key.nvim",
    event = "BufWinEnter",
    opts = {
      disable = { filetypes = { "TelescopePrompt" } },
      window = {
        border = "rounded", -- none, single, double, shadow
      },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    },
  },
}
