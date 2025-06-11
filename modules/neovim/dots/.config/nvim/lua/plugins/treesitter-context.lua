local M = {
  "nvim-treesitter/nvim-treesitter-context",
  version = "*",
}

M.event = { "BufReadPost", "BufNewFile" }

M.config = true

return M
