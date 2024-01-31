local lsp = require("utils.lsp")
local config = require("static.default_lspconfig")

local root_patterns = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
}

local efm = vim.fn.executable("black") == 1
  and lsp.start({
    name = "black",
    cmd = { "efm-langserver" },
    root_patterns = root_patterns,
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        python = {
          {
            formatCommand = "black --no-color -q -",
            formatStdin = true,
          },
        },
      },
    },
  })

lsp.start(lsp.generate_config(config, {
  name = "pyright",
  cmd = { "pyright-langserver", "--stdio" },
  root_patterns = vim.list_extend({ "pyrightconfig.json" }, root_patterns),
  on_attach = efm and function(client, _)
    client.server_capabilities.documentFormattingProvider = false
  end or nil,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}))
