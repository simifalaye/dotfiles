local deps = require("mini.deps")

deps.now(function()
  deps.add({
    source = "neovim/nvim-lspconfig",
    depends = { "b0o/schemastore.nvim" },
  })
end)
