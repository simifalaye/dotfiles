MiniDeps.now_if_args(function()
  MiniDeps.add({
    source = "NMAC427/guess-indent.nvim",
  })

  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
  })
end)
