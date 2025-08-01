local deps = require("mini.deps")

deps.add({
  source = "echasnovski/mini.indentscope",
  checkout = "stable",
})

deps.later(function()
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "│",
  })
end)
