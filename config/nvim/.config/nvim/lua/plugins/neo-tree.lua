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
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Explorer" },
      { "<C-f>", "<cmd>Neotree reveal<CR>", desc = "Explorer Find" },
      { "-", "<cmd>Neotree toggle position=current<CR>", desc = "File Browser" },
      { "_", "<cmd>Neotree position=current %<CR>", desc = "File Browser Find" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
      _G.user_neotree_boot = false
      require("utils.command").augroup("user_neotree_start", {
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
              _G.user_neotree_boot = true
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
              _G.user_neotree_boot = true
              vim.cmd("Neotree position=current " .. vim.fn.argv()[1])
            end
          end,
        },
      })
    end,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = "File" },
          { source = "buffers", display_name = "Bufs" },
          { source = "git_status", display_name = "Git" },
          { source = "diagnostics", display_name = "Diagnostic" },
        },
      },
      commands = {
        system_open = function(state)
          vim.cmd("OpenLink " .. state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = false, -- used by which-key
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          h = "parent_or_close",
          l = "child_or_open",
          o = "open",
          O = "system_open",
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        follow_current_file = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
        },
        hide_by_pattern = {
          "*.o",
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(_)
            if (not _G.user_neotree_boot) then
              return
            end
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_get_name(buf) == "" then
                vim.api.nvim_buf_delete(buf, {force = true})
                _G.user_neotree_boot = false
                break
              end
            end
          end,
          id = "delete_empty_buffers_on_open"
        }
      }
    },
  },
}
