local prequire = require("utils.prequire")
local schemastore = prequire("schemastore")
return {
  cmd = { "vscode-json-languageserver", "--stdio" },
  settings = {
    json = {
      schemas = schemastore and schemastore.json.schemas() or nil,
      validate = { enable = true },
    },
  },
}
