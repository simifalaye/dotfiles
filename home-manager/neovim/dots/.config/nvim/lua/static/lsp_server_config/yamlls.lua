local yamlls_settings = {
  redhat = { telemetry = { enabled = false } },
}
local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  yamlls_settings["yaml"] = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = "",
    },
    schemas = schemastore.json.schemas() or nil,
  }
end

return {
  settings = yamlls_settings,
}
