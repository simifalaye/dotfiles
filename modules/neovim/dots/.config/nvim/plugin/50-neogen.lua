local deps = require("mini.deps")

deps.later(function()
  deps.add({
    source = "danymat/neogen",
  })

  require("neogen").setup({ snippet_engine = "nvim" })

  vim.keymap.set("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
end)
