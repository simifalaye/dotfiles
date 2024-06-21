local function init()
  require("nvim-surround").setup({})
end

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Load nvim-surround",
  once = true,
  callback = function()
    init()
  end,
})
