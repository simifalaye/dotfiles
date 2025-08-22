MiniDeps.add({
  source = "MeanderingProgrammer/render-markdown.nvim",
  checkout = "v8.6.0",
  monitor = "main",
  depends = { "echasnovski/mini.icons" },
})

MiniDeps.later(function()
  require("render-markdown").setup({})
end)
