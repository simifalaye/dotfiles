local lib = require("utils.lib")

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

-- Diagnostics (based on mode toggle in ./ui.lua)
local default_diagnostics = {
  virtual_text = true,
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
_G.user_diagnostics = {
  -- diagnostics off
  [0] = lib.extend_tbl(default_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }),
  -- status only
  lib.extend_tbl(default_diagnostics, { virtual_text = false, signs = false }),
  -- virtual text off, signs on
  lib.extend_tbl(default_diagnostics, { virtual_text = false }),
  -- all diagnostics on
  default_diagnostics,
}

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

-- Ensure we don't load the plugin twice
if vim.g.user_plugin_loaded_lsp_diagnostics then
  return
end
vim.g.user_plugin_loaded_lsp_diagnostics = true

-- Register signs
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Set diagnotics based on mode
vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
