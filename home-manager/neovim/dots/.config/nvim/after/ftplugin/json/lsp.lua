local lsp = require("utils.lsp")

local jsonls_settings = {}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  jsonls_settings["json"] = {
    schemas = schemastore.json.schemas() or nil,
    validate = { enable = true },
  }
end

lsp.start({
  name = "jsonls",
  cmd = { "vscode-json-languageserver", "--stdio" },
  root_patterns = {},
  single_file_support = true,
  init_options = {
    provideFormatter = true,
  },
  settings = jsonls_settings,
})
