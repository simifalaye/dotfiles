local deps = require("mini.deps")

deps.add({
  source = "NMAC427/guess-indent.nvim",
})

deps.later(function()
  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
  })
end)
