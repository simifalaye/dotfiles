return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    version = "*",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
