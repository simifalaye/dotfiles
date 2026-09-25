local lazy = require("utils.lazy")

lazy.now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/windwp/nvim-ts-autotag" },
  })

  require("nvim-ts-autotag").setup()
end)
