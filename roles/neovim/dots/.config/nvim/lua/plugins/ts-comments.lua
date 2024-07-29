local lz = require("utils.lazy").new("ts-comments", function()
  require("ts-comments").setup({})
  return true
end)
lz:events({ "BufRead" })
