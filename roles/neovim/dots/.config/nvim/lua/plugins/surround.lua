local lz = require("utils.lazy").new("surround", function()
  require("nvim-surround").setup({})
  return true
end)
lz:events({ "BufRead" })
