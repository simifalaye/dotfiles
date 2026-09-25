local lazy = require("utils.lazy")

lazy.now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/NMAC427/guess-indent.nvim" },
  })
  require("guess-indent").setup({
    filetype_exclude = {
      "netrw",
      "tutor",
      "markdown", -- Fenced code blocks confuse the heuristics
    },
  })
end)
