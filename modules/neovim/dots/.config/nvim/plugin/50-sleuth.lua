local deps = require("mini.deps")

deps.now_if_args(function()
  deps.add({
    source = "tpope/vim-sleuth",
  })
end)
