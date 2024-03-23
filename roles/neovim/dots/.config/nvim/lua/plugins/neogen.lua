return {
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Neogen" },
    keys = {
      { "g.", "<cmd>Neogen<CR>", desc = "Generate Annotation" },
    },
    opts = { snippet_engine = "luasnip" },
  },
}
