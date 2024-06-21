local function init()
  require("ts-comments").setup({})
end

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Load cmp",
  once = true,
  callback = function()
    init()
  end,
})
