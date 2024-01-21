return {
  {
    "echasnovski/mini.clue",
    version = "*",
    event = "VeryLazy",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },
          { mode = "n", keys = "<localleader>" },
          { mode = "x", keys = "<localleader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },

          -- user_plugin.unimpaired / plugin.surround
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "n", keys = "y" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },
          { mode = "x", keys = "y" },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          config = { width = "auto" },
          delay = 500,
        },
      })
    end,
  },
}
