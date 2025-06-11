local M = {
  "echasnovski/mini.indentscope",
  version = "*",
}

M.event = { "BufReadPost", "BufNewFile" }

M.config = function()
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "│",
  })
end

return M
