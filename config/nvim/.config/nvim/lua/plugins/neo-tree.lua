return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    keys = {
      { "-", "<cmd>Neotree toggle<CR>", desc = "Explorer" },
      { "_", "<cmd>Neotree reveal<CR>", desc = "Open file in explorer" },
    },
    init = function()
      -- Start neo-tree when a directory is given or no arguments
      vim.cmd([[autocmd StdinReadPre * let s:std_in=1]])
      vim.cmd(
        [[autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
        \ execute 'Neotree position=current' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif]]
      )
      vim.cmd(
        [[autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | execute 'Neotree position=current' | endif]]
      )
    end,
    config = function()
      local tree = require("neo-tree")

      -- Setup plugin
      tree.setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_diagnostics = false,
        follow_current_file = false,
        window = {
          width = 25,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["<space>"] = "noop",
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              ".DS_Store",
              "thumbs.db",
              "node_modules",
              "__pycache__",
            },
          },
          follow_current_file = false,
          use_libuv_file_watcher = true,
        },
      })

      local nlog = _G.prequire("neo-tree.log")
      if nlog then
        nlog.new({ level = "warn" }, true)
      end
    end,
  },
}
