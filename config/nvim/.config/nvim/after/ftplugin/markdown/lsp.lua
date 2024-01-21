local lsp = require("utils.lsp")

lsp.start(lsp.generate_config(require("static.default_lspconfig"), {
  name = "marksman",
  cmd = { "marksman", "server" },
  root_patterns = { ".marksman.toml" },
  single_file_support = true,
}))
