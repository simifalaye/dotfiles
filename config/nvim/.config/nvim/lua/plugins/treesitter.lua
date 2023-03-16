return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local ts_config = require("nvim-treesitter.configs")
      local ts_ctx = require("treesitter-context")
      if ts_ctx then
        ts_ctx.setup()
      end

      ts_config.setup({
        ensure_installed = "all",
        -- Some issues with certain perl files
        ignore_install = { "perl" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
        textobjects = {
          lookahead = true,
          select = {
            enable = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["]a"] = "@parameter.inner",
            },
            swap_previous = {
              ["[a"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
        autotag = {
          enable = true,
        },
      })

      -- Enable treesitter folding
      vim.opt.foldenable = true
      vim.opt.foldmethod = "expr" -- use expression folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 20
    end,
  },
}
