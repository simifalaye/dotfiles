local lsp = require("utils.lsp")
local config = require("static.default_lspconfig")

local ansiblels_root_patterns = { "ansible.cfg", ".ansible-lint" }

if
  nil
  ~= require("utils.fs").proj_dir(vim.api.nvim_buf_get_name(0), ansiblels_root_patterns)
then
  vim.bo.filetype = "yaml.ansible"
  lsp.start(lsp.generate_config(config, {
    name = "ansiblels",
    cmd = { "ansible-language-server", "--stdio" },
    root_patterns = ansiblels_root_patterns,
    single_file_support = true,
    settings = {
      ansible = {
        python = {
          interpreterPath = "python",
        },
        ansible = {
          path = "ansible",
        },
        executionEnvironment = {
          enabled = false,
        },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = "ansible-lint",
          },
        },
      },
    },
  }))
  return
end

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

lsp.start(lsp.generate_config(config, {
  name = "yamlls",
  cmd = { "yaml-language-server", "--stdio" },
  root_patterns = {},
  single_file_support = true,
  settings = yamlls_settings,
}))
