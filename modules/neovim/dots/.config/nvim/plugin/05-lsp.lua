vim.lsp.config("*", {
  root_markers = require("utils.fs").root_patterns,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
})

vim.lsp.enable({
  "bashls",
  "clangd",
  "fish_lsp",
  "gopls",
  "jsonls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "pyright",
  "rust_analyzer",
  "yamlls",
})
