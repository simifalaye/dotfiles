local linters_by_ft = {
  cpp = { "cpplint" },
}

return {
  {
    "mfussenegger/nvim-lint",
    init = function ()
      -- Load nvim-lint only when lint file is specified
      require("utils.command").augroup("user_lint_lazyload", {
        {
          desc = "Lazy load gitsigns",
          event = { "BufRead" },
          command = function()
            local ft = vim.bo.filetype
            for key,_ in pairs(linters_by_ft) do
              if ft == key then
                -- Delete augroup
                vim.api.nvim_del_augroup_by_name("user_lint_lazyload")
                vim.schedule(function()
                  -- Load plugin
                  require("lazy").load({ plugins = { "nvim-lint" } })
                  -- Lint file on load
                  require("lint").try_lint(nil, { ignore_errors = true })
                end)
              end
            end
          end,
        },
      })
    end,
    config = function()
      -- Setup linters
      require("lint").linters_by_ft = linters_by_ft
      -- Setup lint-on-save
      require("utils.command").augroup("user_nvim_lint", {
        {
          desc = "Try linting file on save",
          event = "BufWritePost",
          pattern = "*",
          command = function()
            require("lint").try_lint(nil, { ignore_errors = true })
          end,
        },
      })
    end,
  },
}
