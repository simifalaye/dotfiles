local lz = require("utils.lazy").new("mini-indentscope", function()
  local mini_indentscope = require("mini.indentscope")
  mini_indentscope.setup({
    symbol = '╎',
    draw = {
      animation = mini_indentscope.gen_animation.none(),
    },
    mappings = {
      object_scope = "",
      object_scope_with_border = "",
      goto_top = "",
      goto_bottom = "",
    },
  })
  return true
end)
lz:events({ "BufRead" })
