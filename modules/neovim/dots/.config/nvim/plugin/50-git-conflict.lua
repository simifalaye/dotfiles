local deps = require("mini.deps")

deps.add({
  source = "akinsho/git-conflict.nvim",
})

deps.now(function()
  require("git-conflict").setup({})
end)
