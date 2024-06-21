-- Single list to run multiple formatters sequentially
-- Sub-list to run only the first available formatter
local formatters_by_ft = {
  c = { "clang_format" },
  cpp = { "clang_format" },
  lua = { "stylua" },
  javascript = { { "prettierd", "prettier" } },
  javascriptreact = { { "prettierd", "prettier" } },
  python = { "isort", "black" },
  typescript = { { "prettierd", "prettier" } },
  typescriptreact = { { "prettierd", "prettier" } },
  vue = { { "prettierd", "prettier" } },
}

local loaded_conform = false
local function init()
  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
  })
  loaded_conform = true
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Load conform for configured filetypes",
  pattern = vim.tbl_keys(formatters_by_ft),
  callback = function()
    if not loaded_conform then
      init()
    end
    vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()'
  end,
})
