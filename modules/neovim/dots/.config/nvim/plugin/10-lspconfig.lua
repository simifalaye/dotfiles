local deps = require("mini.deps")

deps.add({
  source = "neovim/nvim-lspconfig",
  dependencies = { "b0o/schemastore.nvim" },
})
