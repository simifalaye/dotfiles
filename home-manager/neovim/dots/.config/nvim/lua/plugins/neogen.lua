return {
  "danymat/neogen",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  cmd = { "Neogen" },
  keys = {
    {
      "g.",
      "<cmd>Neogen<CR>",
      desc = "Generate Annotation",
    },
  },
  opts = {
    snippet_engine = "nvim",
  },
}
