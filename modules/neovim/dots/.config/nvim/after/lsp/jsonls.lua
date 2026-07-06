local settings = {}

local schemastore_ok, schemastore = pcall(require, "schemastore")
if schemastore_ok then
  settings["json"] = {
    schemas = schemastore.json.schemas() or nil,
    validate = { enable = true },
  }
end

---@type vim.lsp.Config
local conf = {
  settings = settings,
}
if vim.fn.executable("vscode-json-languageserver") == 1 then
  conf.cmd = function(dispatchers, config)
    local cmd = "vscode-json-languageserver"
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end
end
return conf
