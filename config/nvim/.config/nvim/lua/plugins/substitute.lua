return {
  {
    "gbprod/substitute.nvim",
    keys = {
      {
        "S",
        function()
          require("substitute").visual()
        end,
        mode = "x",
        desc = "Substitute",
      },
      {
        "S",
        function()
          require("substitute").operator()
        end,
        mode = "n",
        desc = "Substitute",
      },
      {
        "X",
        function()
          require("substitute.exchange").operator()
        end,
        mode = "n",
        desc = "eXchange",
      },
      {
        "X",
        function()
          require("substitute.exchange").visual()
        end,
        mode = "x",
        desc = "eXchange",
      },
      {
        "Xc",
        function()
          require("substitute.exchange").cancel()
        end,
        mode = { "n", "x" },
        desc = "eXchange Cancel",
      },
    },
    config = true,
  },
}
