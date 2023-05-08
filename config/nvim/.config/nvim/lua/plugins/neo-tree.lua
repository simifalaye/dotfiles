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
      vim.g.neo_tree_remove_legacy_commands = true
      require("utils.command").augroup("neotree_start", {
        {
          desc = "Start neo-tree when no commands are provided",
          event = "VimEnter",
          pattern = "*",
          command = function()
            local should_skip = false
            if
              vim.fn.argc() > 0
              or vim.fn.line2byte(vim.fn.line("$")) ~= -1
              or not vim.o.modifiable
            then
              should_skip = true
            else
              for _, arg in pairs(vim.v.argv) do
                if
                  arg == "-b"
                  or arg == "-c"
                  or vim.startswith(arg, "+")
                  or arg == "-S"
                then
                  should_skip = true
                  break
                end
              end
            end
            if not should_skip then
              vim.cmd("Neotree position=current")
            end
          end,
        },
        {
          desc = "Start neo-tree when a directory is given",
          event = "VimEnter",
          pattern = "*",
          command = function()
            if
              vim.fn.argc() == 1
              and vim.fn.isdirectory(vim.fn.argv()[1]) == 1
              and vim.fn.exists("s:std_in") ~= 1
            then
              vim.cmd("Neotree position=current " .. vim.fn.argv()[1])
            end
          end,
        },
      })
    end,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_diagnostics = false,
      follow_current_file = false,
      window = {
        width = 30,
        mappings = {
          ["<space>"] = false, -- used by which-key
          ["l"] = "open",
          ["h"] = "close_node",
          ["o"] = "open",
        },
      },
      filesystem = {
        follow_current_file = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
        },
        hide_by_pattern = {
          "*.o",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
  },
}
