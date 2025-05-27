local M = {
  "danymat/neogen",
}

M.event = { "BufReadPost", "BufNewFile", "BufWritePre" }

M.cmd = { "Neogen" }

M.keys = {
  {
    "g.",
    "<cmd>Neogen<CR>",
    desc = "Generate Annotation",
  },
}

M.opts = {
  snippet_engine = "nvim",
}

return M
