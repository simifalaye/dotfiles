local icons = require("static.icons")

local signs = {
  { name = "DiagnosticSignError", text = icons.font.error },
  { name = "DiagnosticSignWarn", text = icons.font.warn },
  { name = "DiagnosticSignHint", text = icons.font.hint },
  { name = "DiagnosticSignInfo", text = icons.font.info },
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
  [0] = vim.tbl_deep_extend("force", default_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }),
  -- status only
  vim.tbl_deep_extend(
    "force",
    default_diagnostics,
    { virtual_text = false, signs = false }
  ),
  -- virtual text off, signs on
  vim.tbl_deep_extend("force", default_diagnostics, { virtual_text = false }),
  -- all diagnostics on
  default_diagnostics,
}

-- Register signs
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Set diagnotics based on mode
vim.g.user_diagnostics_mode = vim.g.user_diagnostics_mode or 2
vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
