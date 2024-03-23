local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
return {
  ls.snippet({ trig = "td", name = "TODO" }, {
    ls.d(1, function()
      local function with_cmt(cmt)
        return string.format(vim.bo.commentstring, " " .. cmt)
      end
      return ls.snippet("", {
        ls.c(1, {
          ls.t(with_cmt("TODO: ")),
          ls.t(with_cmt("FIXME: ")),
          ls.t(with_cmt("HACK: ")),
          ls.t(with_cmt("BUG: ")),
        }),
      })
    end),
    ls.i(0),
  }),
  ls.snippet(
    { trig = "hr", name = "Header" },
    fmt(
      [[
  {1}
  {2} {3}
  {1}
  {4}
  ]],
      {
        ls.f(function()
          local comment =
            string.format(vim.bo.commentstring:gsub(" ", "") or "#%s", "-")
          local col = vim.bo.textwidth or 80
          return comment .. string.rep("-", col - #comment)
        end),
        ls.f(function()
          return vim.bo.commentstring:gsub("%%s", "")
        end),
        ls.i(1, "HEADER"),
        ls.i(0),
      }
    )
  ),
}
