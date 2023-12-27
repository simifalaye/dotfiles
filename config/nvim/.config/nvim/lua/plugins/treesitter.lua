---@param buf integer buffer handler
---@return boolean
local function buf_is_large(_, buf)
  return vim.b[buf].large_file == true
end

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
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      {
        "Wansmer/treesj",
        keys = {
          { "gS", "<Cmd>TSJSplit<CR>", desc = "Split Lines (ts)" },
          { "gJ", "<Cmd>TSJJoin<CR>", desc = "Join Lines (ts)" },
        },
        opts = { use_default_keymaps = false },
      },
      {
        "andymass/vim-matchup",
        config = true,
      },
    },
    opts = {
      ensure_installed = "all",
      -- Some issues with certain perl files
      ignore_install = { "perl", "wgsl", "wgsl_bevy" },
      highlight = {
        enable = true,
        disable = function(_, _)
          return vim.b.large_file
        end,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["am"] = { query = "@function.outer", desc = "A method" },
            ["im"] = { query = "@function.inner", desc = "In method" },
            -- ["al"] = {query = "@loop.outer", desc = "A loop"},
            -- ["il"] = {query = "@loop.inner", desc = "In loop"},
            ["ac"] = { query = "@class.outer", desc = "A class" },
            ["ic"] = { query = "@class.inner", desc = "In class" },
            ["aa"] = { query = "@parameter.outer", desc = "A argument" },
            ["ia"] = { query = "@parameter.inner", desc = "In argument" },
            ["a/"] = { query = "@comment.outer", desc = "A comment" },
            ["a*"] = { query = "@comment.outer", desc = "A comment" },
            ["ao"] = { query = "@block.outer", desc = "A block" },
            ["io"] = { query = "@block.inner", desc = "In block" },
          },
        },
        move = {
          enable = true,
          disable = buf_is_large,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next method start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]a"] = { query = "@parameter.outer", desc = "Next arg start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next method end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]A"] = { query = "@parameter.outer", desc = "Next arg end" },
            ["]]"] = { query = "@comment.outer", desc = "Next comment end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev method start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            ["[a"] = { query = "@parameter.outer", desc = "Prev arg start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev method end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            ["[A"] = { query = "@parameter.outer", desc = "Prev arg end" },
            ["[["] = { query = "@comment.outer", desc = "Prev comment end" },
          },
        },
        swap = {
          enable = true,
          disable = buf_is_large,
          swap_next = {
            ["g}"] = { query = "@parameter.inner", desc = "Swap next arg" },
          },
          swap_previous = {
            ["g{"] = { query = "@parameter.inner", desc = "Swap prev arg" },
          },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = "<S-Enter>",
          node_decremental = "<bs>",
        },
      },
      autotag = { enable = true },
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable = {}, -- optional, list of language that will be disabled
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Enable treesitter folding
      vim.opt.foldenable = false -- disable at startup
      vim.opt.foldmethod = "expr" -- use expression folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local map = require("utils.map")

      -- vim way: ; goes to the direction you were moving.
      map.map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, "Repeat f,t,F,T")
      map.map(
        { "n", "x", "o" },
        ",",
        ts_repeat_move.repeat_last_move_opposite,
        "Repeat f,t,F,T opposite"
      )
    end,
  },
}
