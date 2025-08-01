local deps = require("mini.deps")

deps.add({
  source = "danymat/neogen",
})

deps.now(function()
  local lz = require("utils.lazy").new("neogen", function()
    require("neogen").setup({ snippet_engine = "nvim" })
  end)
  lz:cmds({ "Neogen" })
  lz:events({ "BufReadPost", "BufNewFile", "BufWritePre" })
  lz:key("n", "g.", "<cmd>Neogen<CR>", { desc = "Generate Annotation" })
end)
