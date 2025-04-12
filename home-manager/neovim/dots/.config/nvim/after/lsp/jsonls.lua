local jsonls_settings = {}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  jsonls_settings["json"] = {
    schemas = schemastore.json.schemas() or nil,
    validate = { enable = true },
  }
end

return {
  cmd = { "vscode-json-languageserver", "--stdio" },
  settings = jsonls_settings,
}
