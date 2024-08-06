require("which-key").setup({
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
})
