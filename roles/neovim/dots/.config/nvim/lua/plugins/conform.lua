-- Single list to run multiple formatters sequentially
-- Sub-list to run only the first available formatter
local formatters_by_ft = {
  c = { "clang_format" },
  cpp = { "clang_format" },
  lua = { "stylua" },
  javascript = { { "prettierd", "prettier" } },
  javascriptreact = { { "prettierd", "prettier" } },
  python = { "isort", "black" },
  typescript = { { "prettierd", "prettier" } },
  typescriptreact = { { "prettierd", "prettier" } },
  vue = { { "prettierd", "prettier" } },
}

local lz = require("utils.lazy").new("conform", function()
  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
  })
  return true
end)

vim.api.nvim_create_autocmd("FileType", {
  desc = "Load conform for configured filetypes",
  pattern = vim.tbl_keys(formatters_by_ft),
  callback = function()
    if not lz.loaded then
      lz.loader()
    end
    vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()'
  end,
})
