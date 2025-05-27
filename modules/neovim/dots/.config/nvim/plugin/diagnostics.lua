local icons = require("static.icons")

local text_signs = {
  [vim.diagnostic.severity.ERROR] = icons.font.diagnostics.error,
  [vim.diagnostic.severity.WARN] = icons.font.diagnostics.warn,
  [vim.diagnostic.severity.HINT] = icons.font.diagnostics.hint,
  [vim.diagnostic.severity.INFO] = icons.font.diagnostics.info,
}

-- local short_source_names = {
--   ["Lua Diagnostics."] = "Lua",
--   ["Lua Syntax Check"] = "Lua",
-- }

vim.diagnostic.config({
  -- virtual_text = {
  --   spacing = 4,
  --   prefix = "",
  --   severity = vim.diagnostic.severity.HINT,
  --   format = function(diag)
  --     return string.format(
  --       "%s %s (%s): %s",
  --       text_signs[diag.severity],
  --       short_source_names[diag.source] or diag.source,
  --       diag.code,
  --       diag.message
  --     )
  --   end,
  -- },
  signs = {
    text = text_signs,
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  virtual_lines = {
    current_line = true,
  },
  underline = true,
  severity_sort = true,
})
