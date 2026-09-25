local lazy = require("utils.lazy")

-- Single list to run multiple formatters sequentially
-- Sub-list to run only the first available formatter
local formatters_by_ft = {
  c = { "clang_format" },
  cpp = { "clang_format" },
  go = { "gofmt", "golines", stop_after_first = false },
  javascript = { "prettierd", "prettier" },
  javascriptreact = { "prettierd", "prettier" },
  markdown = { "mdformat" },
  python = { "isort", "black", stop_after_first = false },
  rust = { "rustfmt" },
  typescript = { "prettierd", "prettier" },
  typescriptreact = { "prettierd", "prettier" },
  lua = { "stylua" },
}

local format_on_save_fts = { "markdown" }

lazy.event("FileType", vim.tbl_keys(formatters_by_ft), function()
  vim.pack.add({
    {
      src = "https://github.com/stevearc/conform.nvim",
    },
  })

  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    formatters = {
      mdformat = {
        -- args = { "--number", "-" },
        args = { "-" },
      },
    },
    default_format_opts = {
      timeout_ms = 5000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback",
      stop_after_first = true,
    },
    format_on_save = function(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      if vim.tbl_contains(format_on_save_fts, vim.bo[bufnr].ft) then
        return {
          lsp_format = "fallback",
          timeout_ms = 500,
        }
      end
      return nil
    end,
  })
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
