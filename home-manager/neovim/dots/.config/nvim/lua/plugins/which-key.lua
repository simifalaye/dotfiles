return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      icons = {
        rules = false,
      },
      disable = { filetypes = { "TelescopePrompt" } },
      plugins = {
        presets = {
          nav = false,
          g = false,
        },
      },
    },
  },
}
