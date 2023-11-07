return {
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.0.0",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    config = function()
      vim.tbl_map(function(type)
        require("luasnip.loaders.from_" .. type).lazy_load()
      end, { "vscode", "snipmate", "lua" })
      require("utils.command").command(
        "LuaSnipEditS",
        require("luasnip.extras.snip_location").jump_to_active_snippet,
        {}
      )
    end,
  },
}
