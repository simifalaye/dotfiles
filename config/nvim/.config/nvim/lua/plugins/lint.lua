local augroup = require("utils.augroup")
local linters_by_ft = {
  cpp = { "cpplint" },
  zsh = { "zsh" },
}

return {
  {
    "mfussenegger/nvim-lint",
    init = function()
      -- Load nvim-lint only when a lintable file is specified
      augroup("user_lint_lazyload", {
        {
          desc = "Lazy load linter",
          event = { "BufRead" },
          command = function()
            local ft = vim.bo.filetype
            if linters_by_ft[ft] then
              -- Delete augroup
              vim.api.nvim_del_augroup_by_name("user_lint_lazyload")
              vim.schedule(function()
                -- Load plugin
                require("lazy").load({ plugins = { "nvim-lint" } })
                -- Lint file on load
                require("lint").try_lint(nil, { ignore_errors = true })
              end)
            end
          end,
        },
      })
    end,
    config = function()
      -- Setup linters
      require("lint").linters_by_ft = linters_by_ft
      -- Setup lint-on-save
      augroup("user_nvim_lint", {
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
