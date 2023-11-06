local prequire = require("utils.prequire")
return {
  {
    "echasnovski/mini.ai",
    version = "*",
    dependencies = { "echasnovski/mini.extra", version = false, config = true },
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      local opts = {
        n_lines = 500,
        mappings = {
          around_last = "",
          inside_last = "",
          around_next = "",
          inside_next = "",
        },
        custom_textobjects = {
          B = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
        },
      }
      if prequire("nvim-treesitter-textobjects") ~= nil then
        opts.custom_textobjects.o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {})
        opts.custom_textobjects.f = ai.gen_spec.treesitter(
          { a = "@function.outer", i = "@function.inner" },
          {}
        )
        opts.custom_textobjects.c = ai.gen_spec.treesitter(
          { a = "@class.outer", i = "@class.inner" },
          {}
        )
      end
      return opts
    end,
  },
}
