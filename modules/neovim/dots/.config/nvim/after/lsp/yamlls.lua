local settings = {
  -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
  redhat = { telemetry = { enabled = false } },
  -- formatting disabled by default in yaml-language-server; enable it
  yaml = { format = { enable = true } },
}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  settings["yaml"] = {
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

---@type vim.lsp.Config
return {
  settings = settings,
}
