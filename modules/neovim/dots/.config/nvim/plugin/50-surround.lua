MiniDeps.add({
  source = "kylechui/nvim-surround",
})

MiniDeps.now(function()
  local lz = require("utils.lazy").new("surround", function()
    require("nvim-surround").setup({})
  end)
  lz:events({ "BufReadPost", "BufNewFile", "BufWritePre" })
end)
