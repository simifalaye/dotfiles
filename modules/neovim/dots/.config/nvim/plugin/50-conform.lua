vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
  },
}, { load = function() end })

-- Single list to run multiple formatters sequentially
-- Sub-list to run only the first available formatter
local formatters_by_ft = {
  c = { "clang_format" },
  cpp = { "clang_format" },
  go = { "gofmt", "golines", stop_after_first = false },
  javascript = { "prettierd", "prettier" },
  javascriptreact = { "prettierd", "prettier" },
  python = { "isort", "black", stop_after_first = false },
  rust = { "rustfmt" },
  typescript = { "prettierd", "prettier" },
  typescriptreact = { "prettierd", "prettier" },
  lua = { "stylua" },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(formatters_by_ft),
  once = true,
  callback = function()
    vim.cmd.packadd("conform.nvim")

    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
      default_format_opts = {
        timeout_ms = 5000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback",
        stop_after_first = true,
      },
    })
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
})
