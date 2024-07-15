local lz = require("utils.lazy").new("nvim-surround", function()
  require("nvim-surround").setup({})
  return true
end)
lz:autocmds({ "BufRead" })
