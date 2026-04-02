vim.schedule(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.bufremove",
      version = "stable",
    },
  })

  local bufremove = require("mini.bufremove")
  bufremove.setup()

  vim.keymap.set("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bD", function()
    bufremove.delete(0, true)
  end, { desc = "Delete!" })
  vim.keymap.set("n", "<leader>bw", bufremove.delete, { desc = "Wipeout" })
  vim.keymap.set("n", "<leader>bW", function()
    bufremove.wipeout(0, true)
  end, { desc = "Wipeout!" })
end)
