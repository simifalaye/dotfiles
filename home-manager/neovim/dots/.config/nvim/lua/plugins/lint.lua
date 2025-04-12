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

local M = {
  "mfussenegger/nvim-lint",
  lazy = true,
}

M.init = function()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    desc = "Try linting file on buffer read and write",
    pattern = "*",
    callback = function(args)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      if linters_by_ft[ft] then
        require("lazy").load({ plugins = { "nvim-lint" } })
        local dir = vim.fn.fnamemodify(args.file, ":h")
        require("lint").try_lint(nil, { ignore_errors = true, cwd = dir })
      end
    end,
  })
end

M.config = function()
  require("lint").linters_by_ft = linters_by_ft
end

return M
