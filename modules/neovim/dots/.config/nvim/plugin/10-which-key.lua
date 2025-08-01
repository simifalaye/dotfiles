local deps = require("mini.deps")

deps.add({
  source = "folke/which-key.nvim",
})

deps.later(function()
  require("which-key").setup({
    preset = "helix",
    icons = {
      rules = false,
    },
    disable = { filetypes = { "TelescopePrompt" } },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>", group = "+Global" },
        { "<C-w>", group = "+Window" },
        { "[", group = "+Prev" },
        { "]", group = "+Next" },
        { "g", group = "+Goto" },
        { "gr", group = "+Lsp" },
        { "grw", group = "+Workspace" },
        { "<leader>f", group = "+Find" },
        { "<leader>u", group = "+Ui" },
        { "<leader>w", group = "+Window" },
      },
    },
  })
end)
