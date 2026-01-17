local jsonls_settings = {}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  jsonls_settings["json"] = {
    schemas = schemastore.json.schemas() or nil,
    validate = { enable = true },
  }
end

---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  settings = jsonls_settings,
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { ".git" },
}
