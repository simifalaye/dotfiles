local deps = require("mini.deps")

deps.add({
  source = "windwp/nvim-ts-autotag",
})

deps.later(function()
  require("nvim-ts-autotag").setup()
end)
