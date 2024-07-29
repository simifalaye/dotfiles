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

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Show Buffer-local Keys" })
