MiniDeps.add({
  source = "stevearc/quicker.nvim",
})

MiniDeps.later(function()
  local icons = require("static.icons")
  local quicker = require("quicker")

  quicker.setup({
    use_default_opts = false,
    opts = {
      -- Required for type icons to work
      signcolumn = "auto",
    },
    highlight = {
      lsp = false,
      treesitter = true,
      load_buffers = false,
    },
    type_icons = {
      E = icons.Font.Diag.Error,
      W = icons.Font.Diag.Warn,
      I = icons.Font.Diag.Info,
      N = icons.Font.Diag.Hint,
      H = icons.Font.Diag.Hint,
    },
    on_qf = function(buf)
      -- Disable custom qf syntax, see `syntax/qf.vim`
      vim.bo[buf].syntax = ""
    end,
    max_filename_width = function()
      return math.max(32, math.ceil(vim.go.columns / 4))
    end,
    keys = {
      {
        ">",
        function()
          quicker.expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          quicker.collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>uq", function()
    require("quicker").toggle()
  end, {
    desc = "Toggle quickfix",
  })
  vim.keymap.set("n", "<leader>ul", function()
    require("quicker").toggle({ loclist = true })
  end, {
    desc = "Toggle loclist",
  })
end)
