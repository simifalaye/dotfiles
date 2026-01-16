local deps = require("mini.deps")

deps.now(function()
  -- Setup linters
  local linters_by_ft = {
    c = { "cpplint" },
    cpp = { "cpplint" },
    go = { "golangcilint" },
    javascript = { "eslint" },
    javascriptreact = { "eslint" },
    python = { "flake8" },
    typescript = { "eslint" },
    typescriptreact = { "eslint" },
  }

  deps.add({
    source = "mfussenegger/nvim-lint",
  })

  local lz = require("utils.lazy").new("lint", function()
    require("lint").linters_by_ft = linters_by_ft
  end)
  lz:fts(vim.tbl_keys(linters_by_ft))

  local grp = vim.api.nvim_create_augroup("user_plugin_lazydev", {})
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    desc = "Try linting file on buffer read and write",
    pattern = vim.tbl_keys(linters_by_ft),
    group = grp,
    callback = function(args)
      local dir = vim.fn.fnamemodify(args.file, ":h")
      require("lint").try_lint(nil, { ignore_errors = true, cwd = dir })
    end,
  })
end)
