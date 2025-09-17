MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-mini/mini.indentscope",
    checkout = "stable",
  })

  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "│",
  })
end)
