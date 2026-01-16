local deps = require("mini.deps")

deps.now(function()
  deps.add({
    source = "oskarnurm/koda.nvim",
  })

  vim.o.termguicolors = true
  vim.cmd.colorscheme("koda")
end)
