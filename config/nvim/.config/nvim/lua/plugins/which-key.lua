return {
  {
    "folke/which-key.nvim",
    event = "BufWinEnter",
    opts = {
      plugins = {
        registers = false,
        spelling = true, -- Spelling hints with z=
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
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
