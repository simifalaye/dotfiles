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

return {
  {
    "stevearc/conform.nvim",
    event = "BufRead",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(formatters_by_ft),
        group = vim.api.nvim_create_augroup("conform_formatexpr", { clear = true }),
        callback = function()
          vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()'
        end,
      })
    end,
    opts = {
      formatters_by_ft = formatters_by_ft,
    },
  },
}
