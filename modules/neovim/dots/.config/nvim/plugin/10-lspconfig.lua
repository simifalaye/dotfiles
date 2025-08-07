local deps = require("mini.deps")

deps.add({
  source = "neovim/nvim-lspconfig",
  depends = { "b0o/schemastore.nvim" },
})
