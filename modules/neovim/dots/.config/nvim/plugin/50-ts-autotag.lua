local deps = require("mini.deps")

deps.later(function()
  deps.add({
    source = "windwp/nvim-ts-autotag",
  })

  require("nvim-ts-autotag").setup()
end)
