local lz = require("utils.lazy").new("neogen", function()
  require("neogen").setup({
    snippet_engine = "nvim",
  })
  return true
end)
lz:autocmds({ "BufRead" })
lz:cmds({ "Neogen" })
lz:key("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
