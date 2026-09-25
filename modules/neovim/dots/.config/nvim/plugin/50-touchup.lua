local lazy = require("utils.lazy")

lazy.later(function()
  vim.pack.add({
    {
      src = "https://github.com/noisesfromspace/touchup.nvim",
    },
  })
  require("touchup").setup({
    bullets = { enabled = true, icons = { "✸", "✿", "✦", "✧" } },
    checkboxes = { enabled = true },
    code_blocks = { enabled = true },
    markers = { enabled = true },
    quotes = { enabled = true },
    enter = { enabled = true },
  })
end)
