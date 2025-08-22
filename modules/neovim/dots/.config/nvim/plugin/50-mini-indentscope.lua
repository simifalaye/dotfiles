MiniDeps.add({
  source = "echasnovski/mini.indentscope",
  checkout = "stable",
})

MiniDeps.later(function()
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "│",
  })
end)
