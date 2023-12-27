return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local augroup = require("utils.augroup")
      local indentscope = require("mini.indentscope")
      indentscope.setup({
        draw = {
          delay = 0,
          animation = indentscope.gen_animation.none(),
        },
        -- Which character to use for drawing scope indicator
        -- alternative styles: ┆ ┊ ╎
        -- symbol = "│",
        symbol = "┆",
        options = { try_as_border = true },
      })
      -- Disable for certain filetypes
      augroup("MiniIndentscopeDisable", {
        {
          desc = "Highlight window when focused",
          event = "FileType",
          pattern = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
            "fzf",
            "minifiles",
          },
          command = function()
            ---@diagnostic disable-next-line: inject-field
            vim.b.miniindentscope_disable = true
          end,
        },
      })
    end,
  },
}
