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
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
      {
        "Wansmer/treesj",
        keys = {
          { "gS", "<Cmd>TSJSplit<CR>", desc = "Split Lines (ts)" },
          { "gJ", "<Cmd>TSJJoin<CR>", desc = "Join Lines (ts)" },
        },
        opts = { use_default_keymaps = false },
      },
    },
    opts = {
      ensure_installed = "all",
      -- Some issues with certain perl files
      ignore_install = { "perl", "wgsl", "wgsl_bevy" },
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
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
