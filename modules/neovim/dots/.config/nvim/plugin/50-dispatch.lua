local lazy = require("utils.lazy")

lazy.now(function()
  vim.pack.add({
    { src = "https://github.com/tpope/vim-dispatch.git" },
  })
end)
