MiniDeps.add({
  source = "MeanderingProgrammer/render-markdown.nvim",
  checkout = "v8.6.0",
  monitor = "main",
  depends = { "nvim-tree/nvim-web-devicons" },
})

MiniDeps.later(function()
  require("render-markdown").setup({})
end)
