return {
  {
    "L3MON4D3/LuaSnip",
    tag = "v1.0.0",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
      vim.tbl_map(function(type)
        require("luasnip.loaders.from_" .. type).lazy_load()
      end, { "vscode", "snipmate", "lua" })
    end,
  },
}
