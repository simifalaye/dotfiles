local settings = {}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  settings["json"] = {
    schemas = schemastore.json.schemas() or nil,
    validate = { enable = true },
  }
end

---@type vim.lsp.Config
return {
  settings = settings,
}
