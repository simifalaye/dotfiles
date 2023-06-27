return {
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Neogen" },
    keys = {
      { "<leader>cg", "<cmd>Neogen<CR>", desc = "Generate Annotation" },
    },
    opts = { snippet_engine = "luasnip" },
  },
}
