MiniDeps.add({
  source = "windwp/nvim-ts-autotag",
})

MiniDeps.later(function()
  require("nvim-ts-autotag").setup()
end)
