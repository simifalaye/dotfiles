local deps = require("mini.deps")

deps.add({
  source = "karb94/neoscroll.nvim",
})

deps.later(function()
  require("neoscroll").setup({})
end)
