local lz = require("utils.lazy").new("lsp", function()
  local lspconfig = require("lspconfig")

  -- Register servers servers
  local server_configs = require("static.lsp_server_config")()
  for name, conf in pairs(server_configs) do
    local cmd = conf.cmd or lspconfig[name].document_config.default_config.cmd
    if not cmd or vim.fn.executable(cmd[1]) == 0 then
      conf.autostart = false
    end
    lspconfig[name].setup(conf)
  end

  return true
end)
lz:events({ "BufReadPre" })
