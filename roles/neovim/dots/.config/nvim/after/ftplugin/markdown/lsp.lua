local lsp = require("utils.lsp")

lsp.start({
  name = "marksman",
  cmd = { "marksman", "server" },
  root_patterns = { ".marksman.toml" },
  single_file_support = true,
})
