return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    dependencies = {
      "windwp/nvim-ts-autotag",
      { "folke/ts-comments.nvim", config = true },
      {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {},
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = "all",
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>", -- maps in normal mode to init the node/scope selection
          node_incremental = "<CR>", -- increment to the upper named parent
          node_decremental = "<BS>", -- decrement to the previous node
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]a"] = "@parameter.inner",
            ["]c"] = "@class.outer",
            ["]m"] = "@function.outer",
          },
          goto_next_end = {
            ["]A"] = "@parameter.inner",
            ["]C"] = "@class.outer",
            ["]m"] = "@function.outer",
          },
          goto_previous_start = {
            ["[a"] = "@parameter.inner",
            ["[c"] = "@class.outer",
            ["[m"] = "@function.outer",
          },
          goto_previous_end = {
            ["[A"] = "@parameter.inner",
            ["[C"] = "@class.outer",
            ["[m"] = "@function.outer",
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
