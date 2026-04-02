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

vim.pack.add({
  {
    src = "https://github.com/mfussenegger/nvim-lint",
  },
}, { load = function() end })

local grp = vim.api.nvim_create_augroup("user_plugin_lint", {})
vim.api.nvim_create_autocmd("FileType", {
  desc = "Load nvim-lint on ft",
  pattern = vim.tbl_keys(linters_by_ft),
  group = grp,
  once = true,
  callback = function()
    vim.cmd.packadd("nvim-lint")

    require("lint").linters_by_ft = linters_by_ft
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  desc = "Try linting file on buffer read and write",
  pattern = vim.tbl_keys(linters_by_ft),
  group = grp,
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":h")
    require("lint").try_lint(nil, { ignore_errors = true, cwd = dir })
  end,
})
