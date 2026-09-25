local lazy = require("utils.lazy")

lazy.now(function()
  vim.pack.add({ "https://github.com/willothy/flatten.nvim" })
  require("flatten").setup()
end)
