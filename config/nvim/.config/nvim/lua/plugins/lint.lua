local linters_by_ft = {
  cpp = { "cpplint" },
  zsh = { "zsh" },
}

local user_plugin_nvim_lint_grp_id

return {
  {
    "mfussenegger/nvim-lint",
    init = function()
      user_plugin_nvim_lint_grp_id =
        vim.api.nvim_create_augroup("user_plugin_nvim_lint", {})
      local id
      id = vim.api.nvim_create_autocmd("BufRead", {
        desc = "Lazy load linter when a lintable file is read",
        group = user_plugin_nvim_lint_grp_id,
        callback = function()
          local ft = vim.bo.filetype
          if linters_by_ft[ft] then
            vim.api.nvim_del_autocmd(id)
            vim.schedule(function()
              -- Load plugin
              require("lazy").load({ plugins = { "nvim-lint" } })
              -- Lint file on load
              require("lint").try_lint(nil, { ignore_errors = true })
            end)
          end
        end,
      })
    end,
    config = function()
      -- Setup linters
      require("lint").linters_by_ft = linters_by_ft
      -- Setup lint-on-save
      vim.api.nvim_create_autocmd("BufWritePost", {
        desc = "Try linting file on save",
        group = user_plugin_nvim_lint_grp_id,
        pattern = "*",
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
