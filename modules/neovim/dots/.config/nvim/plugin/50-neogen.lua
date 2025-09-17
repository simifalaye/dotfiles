MiniDeps.later(function()
  MiniDeps.add({
    source = "danymat/neogen",
  })

  require("neogen").setup({ snippet_engine = "nvim" })

  vim.keymap.set("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
end)
