local deps = require("mini.deps")

deps.add({
  source = "MeanderingProgrammer/render-markdown.nvim",
  checkout = "v8.6.0",
  monitor = "main",
  dependencies = { "echasnovski/mini.icons" },
})

deps.later(function()
  require("render-markdown").setup({})
end)
