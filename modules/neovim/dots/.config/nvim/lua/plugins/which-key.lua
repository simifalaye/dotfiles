local M = {
  "folke/which-key.nvim",
}

M.opts = {
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
      { "<leader><tab>", group = "+Tab" },
      { "<leader>b", group = "+Buffer" },
      { "<leader>f", group = "+Find" },
      { "<leader>q", group = "+Quit" },
      { "<leader>u", group = "+Ui" },
      { "<leader>w", group = "+Window" },
    },
  },
}

return M
