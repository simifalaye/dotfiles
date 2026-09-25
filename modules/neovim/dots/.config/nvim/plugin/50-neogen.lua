local lazy = require("utils.lazy")

lazy.later(function()
  vim.pack.add({
    { src = "https://github.com/danymat/neogen" },
  })

  require("neogen").setup({ snippet_engine = "nvim" })

  vim.keymap.set("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
end)
