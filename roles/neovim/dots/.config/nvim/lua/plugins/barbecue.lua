return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    event = "BufRead",
    opts = {
      symbols = {
        modified = "●",
        ellipsis = "…",
        separator = ">",
      },
      kinds = false,
    },
  },
}
