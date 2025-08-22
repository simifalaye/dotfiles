MiniDeps.add({
  source = "NMAC427/guess-indent.nvim",
})

MiniDeps.later(function()
  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
  })
end)
