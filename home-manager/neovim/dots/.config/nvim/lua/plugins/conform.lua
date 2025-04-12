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

return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Load conform for configured filetypes",
        pattern = vim.tbl_keys(formatters_by_ft),
        callback = function()
          require("lazy").load({ plugins = { "conform.nvim" } })
        end,
      })
    end,
    config = function()
      require("conform").setup({
        formatters_by_ft = formatters_by_ft,
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = "fallback",
          stop_after_first = true,
        },
      })
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
