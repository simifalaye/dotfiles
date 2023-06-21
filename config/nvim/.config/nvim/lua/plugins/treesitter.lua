return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local ts_config = require("nvim-treesitter.configs")

      ts_config.setup({
        ensure_installed = "all",
        -- Some issues with certain perl files
        ignore_install = { "perl" },
        highlight = {
          enable = true,
          disable = function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
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
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        autotag = { enable = true },
      })

      -- Enable treesitter folding
      vim.opt.foldenable = false -- disable at startup
      vim.opt.foldmethod = "expr" -- use expression folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
