local deps = require("mini.deps")

deps.add({
  source = "kylechui/nvim-surround",
})

deps.now(function()
  local lz = require("utils.lazy").new("render-markdown", function()
    require("nvim-surround").setup({})
  end)
  lz:events({ "BufReadPost", "BufNewFile", "BufWritePre" })
end)
