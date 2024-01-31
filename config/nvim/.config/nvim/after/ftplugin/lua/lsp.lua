local lsp = require("utils.lsp")
local config = require("static.default_lspconfig")
local neodev_lsp_ok, neodev_lsp = pcall(require, "neodev.lsp")

local before_init = nil
if neodev_lsp_ok then
  before_init = neodev_lsp.before_init
end

local stylua_root_patterns = { "stylua.toml", ".stylua.toml" }

local efm = vim.fn.executable("stylua") == 1
  and lsp.start(
    lsp.generate_config(config, {
      cmd = { "efm-langserver" },
      name = "stylua",
      root_pattern = stylua_root_patterns,
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        languages = {
          lua = {
            {
              formatStdin = true,
              formatCanRange = true,
              formatCommand = "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} -",
              rootMarkers = stylua_root_patterns,
            },
          },
        },
      },
    }),
    nil,
    false
  )

lsp.start(lsp.generate_config(config, {
  name = "luals",
  cmd = { "lua-language-server" },
  root_patterns = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
  },
  on_attach = efm and function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end or nil,
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {
    Lua = {
      workspace = {
        maxPreload = 8000,
        checkThirdParty = false, -- fixes popup issue
      },
    },
  },
  before_init = before_init,
}))
