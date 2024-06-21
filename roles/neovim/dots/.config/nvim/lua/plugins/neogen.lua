local function init()
  require("neogen").setup({
    snippet_engine = "nvim",
  })

  vim.keymap.set("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
end

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Load neogen",
  once = true,
  callback = function()
    init()
  end,
})
