return {
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Neogen" },
    keys = {
      { "<leader>a", "<cmd>Neogen<CR>", desc = "Generate (a)nnotations" },
    },
    opts = { snippet_engine = "luasnip" },
  },
}
