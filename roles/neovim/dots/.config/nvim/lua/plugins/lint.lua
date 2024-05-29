local linters_by_ft = {
  c = { "cpplint" },
  cpp = { "cpplint" },
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
  python = { "flake8" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  vue = { "eslint" },
  ["yaml.ansible"] = { "ansible_lint" },
}

return {
  {
    "mfussenegger/nvim-lint",
    event = "BufRead",
    config = function()
      -- Setup linters & lint buffer on load
      require("lint").linters_by_ft = linters_by_ft
      require("lint").try_lint(nil, { ignore_errors = true })
      -- Setup augroup
      local lint_groupid = vim.api.nvim_create_augroup("user_plugin_lint", {})
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = lint_groupid,
        desc = "Try linting file on buffer read",
        pattern = "*",
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
      -- Setup lint-on-save
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = lint_groupid,
        desc = "Try linting file on save",
        pattern = "*",
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
