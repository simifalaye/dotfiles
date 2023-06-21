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
        symbol = "╎",
      })
      -- Disable for certain filetypes
      require("utils.command").augroup("MiniIndentscopeDisable", {
        {
          desc = "Highlight window when focused",
          event = "BufEnter",
          pattern = "*",
          set = function()
            vim.g.user_indent_scope_ft_disable = {
              "help",
              "startify",
              "aerial",
              "alpha",
              "dashboard",
              "lazy",
              "neogitstatus",
              "NvimTree",
              "neo-tree",
              "Trouble",
              "ranger",
              "rnvimr",
            }
            vim.g.user_indent_scope_bt_disable = { "nofile", "terminal" }
          end,
          command = function()
            if
              vim.tbl_contains(vim.g.user_indent_scope_ft_disable, vim.bo.ft)
              or vim.tbl_contains(vim.g.user_indent_scope_bt_disable, vim.bo.bt)
            then
              vim.b.miniindentscope_disable = true
            end
          end,
        },
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    keys = {
      { "sa", desc = "Surround add", mode = { "n", "x" } },
      { "sd", desc = "Surround delete" },
      { "sr", desc = "Surround replace" },
      { "sf", desc = "Surround find" },
      { "sF", desc = "Surround find left" },
      { "sh", desc = "Surround highlight" },
    },
    opts = {
      mappings = {
        update_n_lines = "",
      },
      -- Number of lines within which surrounding is searched
      n_lines = 62,
      -- How to search for surrounding (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  {
    "echasnovski/mini.bracketed",
    version = "*",
    event = "BufRead",
    config = function()
      require("mini.bracketed").setup()
    end,
  },
  {
    "echasnovski/mini.bufremove",
    version = "*",
    event = "BufRead",
    keys = {
      {
        "<leader>x",
        "<cmd>lua MiniBufremove.delete()<CR>",
        desc = "Delete Buffer",
      },
      {
        "<leader>X",
        "<cmd>lua MiniBufremove.wipeout()<CR>",
        desc = "Wipe Buffer",
      },
    },
    config = function()
      require("mini.bufremove").setup()
    end,
  },
}
