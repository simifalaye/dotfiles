local ls = require("luasnip")
return {
  ls.snippet({
    trig = "mod",
    name = "Define module",
    dscr = "Template for a new module",
  }, {
    ls.t({
      "local M = {}",
      "",
      "M.init = function()",
      "end",
      "",
      "return M",
    }),
  }),
}
