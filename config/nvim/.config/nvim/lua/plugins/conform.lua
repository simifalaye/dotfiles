return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        sh = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
