local lazy = require("utils.lazy")

lazy.later(function()
  vim.pack.add({
    {
      src = "https://github.com/kylechui/nvim-surround",
      version = vim.version.range("*"),
    },
  })
end)
