local neodev_lsp_ok, neodev_lsp = pcall(require, "neodev.lsp")
local before_init = nil
if neodev_lsp_ok then
  before_init = neodev_lsp.before_init
end

local lsp = require("utils.lsp")
lsp.start(lsp.generate_config(require("static.lspconfig"), {
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
