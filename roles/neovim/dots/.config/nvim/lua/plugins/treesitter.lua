---@param buf integer buffer handler
---@return boolean
local function buf_is_large(_, buf)
  return vim.b["midfile"]
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
    },
    opts = {
      ensure_installed = "all",
      -- Some issues with certain perl files
      ignore_install = { "perl", "wgsl", "wgsl_bevy" },
      highlight = {
        enable = true,
        disable = buf_is_large
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "A block" },
            ["ik"] = { query = "@block.inner", desc = "In block" },
            ["ac"] = { query = "@class.outer", desc = "A class" },
            ["ic"] = { query = "@class.inner", desc = "In class" },
            ["a?"] = { query = "@conditional.outer", desc = "A conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "In conditional" },
            ["am"] = { query = "@function.outer", desc = "A method" },
            ["im"] = { query = "@function.inner", desc = "In method" },
            ["al"] = { query = "@loop.outer", desc = "A loop" },
            ["il"] = { query = "@loop.inner", desc = "In loop" },
            ["aa"] = { query = "@parameter.outer", desc = "A arg" },
            ["ia"] = { query = "@parameter.inner", desc = "In arg" },
          },
        },
        move = {
          enable = true,
          disable = buf_is_large,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]m"] = { query = "@function.outer", desc = "Next method start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next arg start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]M"] = { query = "@function.outer", desc = "Next method end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next arg end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Prev block start" },
            ["[m"] = { query = "@function.outer", desc = "Prev method start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            ["[a"] = { query = "@parameter.inner", desc = "Prev arg start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Prev block end" },
            ["[M"] = { query = "@function.outer", desc = "Prev method end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            ["[A"] = { query = "@parameter.inner", desc = "Prev arg end" },
          },
        },
        swap = {
          enable = true,
          disable = buf_is_large,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">m"] = { query = "@function.outer", desc = "Swap next method" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next arg" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<m"] = { query = "@function.outer", desc = "Swap previous method" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous arg" },
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
