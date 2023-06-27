return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(opts)
      return require("utils").extend_tbl(opts, require("alpha.themes.startify").config)
    end,
  },
}
