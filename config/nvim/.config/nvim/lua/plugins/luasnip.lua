local prequire = require("utils.prequire")
return {
  {
    "L3MON4D3/LuaSnip",
    tag = "v1.0.0",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "benfowler/telescope-luasnip.nvim",
    },
    event = "InsertEnter",
    config = function()
      vim.tbl_map(function(type)
        require("luasnip.loaders.from_" .. type).lazy_load()
      end, { "vscode", "snipmate", "lua" })
      -- Setup telescope extension if available
      local telescope = prequire("telescope")
      if telescope then
        telescope.load_extension("luasnip")
        require("utils.map").nnoremap(
          "<leader>sS",
          "<cmd>Telescope luasnip<CR>",
          "Snippets"
        )
      end
    end,
  },
}
