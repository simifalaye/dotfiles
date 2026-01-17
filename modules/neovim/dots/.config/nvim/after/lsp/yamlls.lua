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
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
  root_markers = { ".git" },
  settings = settings,
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
    --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
    --- autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}
