MiniDeps.later(function()
  MiniDeps.add({
    source = "kylechui/nvim-surround",
  })

  local lz = require("utils.lazy").new("surround", function()
    require("nvim-surround").setup({})
  end)
  lz:events({ "BufReadPost", "BufNewFile", "BufWritePre" })
end)
