return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = "BufRead",
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
          command = "if index(['fzf', 'help'], &ft) >= 0 "
            .. "|| index(['nofile', 'terminal'], &bt) >= 0 "
            .. "| let b:miniindentscope_disable=v:true | endif",
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
    version = false,
    lazy = false,
    config = function ()
      require("mini.bracketed").setup()
    end
  },
  {
    'echasnovski/mini.pairs',
    event = "InsertEnter",
    version = '*',
    config = function ()
      require("mini.pairs").setup({})
    end,
  },
}
