local M = {
  "folke/which-key.nvim",
}

M.opts = {
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
}

return M
