return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
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

      local groupid = vim.api.nvim_create_augroup("user_plugin_mini_indentscope", {})
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Highlight window when focused",
        group = groupid,
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
        callback = function()
          vim.b["miniindentscope_disable"] = true
        end,
      })
      vim.api.nvim_create_autocmd("BufReadPre", {
        desc = "Highlight window when focused",
        group = groupid,
        callback = function()
          if vim.b["bigfile"] then
            vim.b["miniindentscope_disable"] = true
          end
        end,
      })
    end,
  },
}
