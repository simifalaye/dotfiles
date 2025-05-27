local M = {
  "kylechui/nvim-surround",
  version = "*",   -- Use for stability; omit to use `main` branch for the latest features
}

M.event = { "BufReadPost", "BufNewFile", "BufWritePre" }

M.opts = {}

return M
