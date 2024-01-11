local prequire = require("utils.prequire")
local schemastore = prequire("schemastore")
if schemastore then
  return {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = schemastore and schemastore.json.schemas() or nil,
      },
    },
  }
end
return {}
