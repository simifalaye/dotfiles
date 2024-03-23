local ok, schemastore = pcall(require, "schemastore")
if ok then
  return {
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  }
end
return {}
