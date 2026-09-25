local lazy = require("utils.lazy")

lazy.now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/tpope/vim-rsi" },
  })
end)
