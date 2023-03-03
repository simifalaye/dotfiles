return {
  {
    "gbprod/substitute.nvim",
    keys = {
      {
        "R",
        "<cmd>lua require('substitute').operator()<cr>",
        desc = "Substitute",
      },
      {
        "RR",
        "<cmd>lua require('substitute').line()<cr>",
        desc = "Substitute line",
      },
      {
        "R",
        "<cmd>lua require('substitute').visual()<cr>",
        desc = "Substitute",
        mode = "x",
      },
    },
    config = true,
  },
}
