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
    },
    opts = {
      ensure_installed = "all",
      -- Some issues with certain perl files
      ignore_install = { "perl", "wgsl", "wgsl_bevy" },
      highlight = {
        enable = true,
        disable = function(_, _)
          return vim.b["bigfile"]
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
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            ["]a"] = { query = "@parameter.outer", desc = "Next arg start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next method end" },
            ["]["] = { query = "@class.outer", desc = "Next class end" },
            ["]A"] = { query = "@parameter.outer", desc = "Next arg end" },
            ["]c"] = { query = "@comment.outer", desc = "Next comment end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev method start" },
            ["[["] = { query = "@class.outer", desc = "Prev class start" },
            ["[a"] = { query = "@parameter.outer", desc = "Prev arg start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev method end" },
            ["[]"] = { query = "@class.outer", desc = "Prev class end" },
            ["[A"] = { query = "@parameter.outer", desc = "Prev arg end" },
            ["[c"] = { query = "@comment.outer", desc = "Prev comment end" },
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
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Enable treesitter folding
      vim.opt.foldenable = false -- disable at startup
      vim.opt.foldmethod = "expr" -- use expression folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
