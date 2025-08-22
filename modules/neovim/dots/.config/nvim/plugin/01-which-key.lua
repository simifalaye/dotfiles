MiniDeps.add({
  source = "folke/which-key.nvim",
})

MiniDeps.later(function()
  require("which-key").setup({
    preset = "classic",
    delay = 500,
    icons = {
      rules = false,
    },
    layout = { align = "center" },
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
