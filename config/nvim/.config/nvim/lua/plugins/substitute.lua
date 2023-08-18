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
      },
      {
        "S",
        function()
          require("substitute").operator()
        end,
        mode = "n",
      },
      {
        "X",
        function()
          require("substitute.exchange").operator()
        end,
        mode = "n",
      },
      {
        "X",
        function()
          require("substitute.exchange").visual()
        end,
        mode = "x",
      },
      {
        "Xc",
        function()
          require("substitute.exchange").cancel()
        end,
        mode = { "n", "x" },
      },
    },
    config = true,
  },
}
