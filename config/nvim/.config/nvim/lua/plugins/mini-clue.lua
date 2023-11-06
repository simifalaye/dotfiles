return {
  {
    "echasnovski/mini.clue",
    version = false,
    event = "BufWinEnter",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        clues = {
          {
            { mode = "n", keys = "<Leader>g", desc = "+git" },
            { mode = "n", keys = "<Leader>n", desc = "+notes" },
            { mode = "n", keys = "<Leader>p", desc = "+plugins" },
            { mode = "n", keys = "<Leader>u", desc = "+ui" },
          },
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows({ submode_resize = true }),
          miniclue.gen_clues.z(),
        },

        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- mini.basics
          { mode = "n", keys = [[\]] },

          -- mini.bracketed
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },

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
        },

        window = { config = { width = "auto", border = "double" }, delay = 500 },
      })
      -- Enable triggers in help buffer
      local clue_group = vim.api.nvim_create_augroup("my-miniclue", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "help",
        group = clue_group,
        callback = function(data)
          miniclue.enable_buf_triggers(data.buf)
        end,
      })
    end,
  },
}
