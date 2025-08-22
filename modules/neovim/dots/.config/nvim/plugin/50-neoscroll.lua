MiniDeps.add({
  source = "karb94/neoscroll.nvim",
})

MiniDeps.later(function()
  require("neoscroll").setup({})
end)
