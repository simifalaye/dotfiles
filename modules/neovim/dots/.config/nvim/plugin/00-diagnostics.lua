local icons = require("static.icons")

local text_signs = {
  [vim.diagnostic.severity.ERROR] = icons.Font.Diag.Error,
  [vim.diagnostic.severity.WARN] = icons.Font.Diag.warn,
  [vim.diagnostic.severity.HINT] = icons.Font.Diag.Hint,
  [vim.diagnostic.severity.INFO] = icons.Font.Diag.Info,
}

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = text_signs,
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

vim.fn.sign_define(
  "DiagnosticSignError",
  { text = icons.Font.Diag.Error, texthl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  { text = icons.Font.Diag.warn, texthl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo",
  { text = icons.Font.Diag.Info, texthl = "DiagnosticSignInfo" }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  { text = icons.Font.Diag.Hint, texthl = "DiagnosticSignHint" }
)
