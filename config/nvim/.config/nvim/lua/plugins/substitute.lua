local substitute = require("utils.lib").reqcall("substitute") ---@module 'substitute'
local exchange = require("utils.lib").reqcall("substitute.exchange") ---@module 'substitute.exchange'

return {
  {
    "gbprod/substitute.nvim",
    keys = {
      { "s", substitute.operator, desc = "Substitute" },
      { "ss", substitute.line, desc = "Substitute Line" },
      { "S", substitute.eol, desc = "Substitute Eol" },
      {
        "s",
        substitute.visual,
        mode = "x",
        desc = "Substitute",
      },
      { "sx", exchange.operator, desc = "Exchange" },
      { "sxx", exchange.line, desc = "Exchange line" },
      { "sxc", exchange.cancel, desc = "Exchange cancel" },
      {
        "X",
        exchange.visual,
        mode = "x",
        desc = "Exchange",
      },
    },
    init = function()
      vim.keymap.set("n", "s", "s", { desc = "+sub/xchange" })
    end,
    config = true,
  },
}
