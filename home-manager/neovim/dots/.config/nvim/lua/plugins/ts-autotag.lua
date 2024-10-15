local lz = require("utils.lazy").new("ts-autotag", function()
  require("nvim-ts-autotag").setup({})
  return true
end)
lz:events({ "BufRead" })
