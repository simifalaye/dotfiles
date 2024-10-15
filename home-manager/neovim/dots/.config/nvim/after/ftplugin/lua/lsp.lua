local lsp = require("utils.lsp")

local efm = false
local efm_fmt = false
local efm_cfg = {
  cmd = { "efm-langserver" },
  name = "stylua",
  root_pattern = {},
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    languages = {
      lua = {},
    },
  },
}

if vim.fn.executable("stylua") == 1 then
  local stylua_root_patterns = { "stylua.toml", ".stylua.toml" }
  efm_cfg.root_pattern = vim.list_extend(efm_cfg.root_pattern, stylua_root_patterns)
  table.insert(efm_cfg.settings.languages.lua, {
    formatStdin = true,
    formatCanRange = true,
    formatCommand = "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} -",
    rootMarkers = stylua_root_patterns,
  })
  efm_fmt = true
  efm = true
end

if efm then
  lsp.start(efm_cfg)
end
lsp.start({
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
    documentFormatting = not efm_fmt,
    documentRangeFormatting = not efm_fmt,
  },
  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {
    Lua = {
      workspace = {
        maxPreload = 8000,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
