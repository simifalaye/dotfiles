local augroup = require("utils.command").augroup
return {
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "-",
        function()
          require("mini.files").open()
        end,
        desc = "Open file browser",
      },
      {
        "_",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Open file browser (file)",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        -- Manual autocmd setup since netrw is disabled completely (in lazy.nvim)
        use_as_default_explorer = false,
      },
    },
    init = function()
      -- Setup autocommands
      augroup("user_mini_files", {
        {
          desc = "Start mini.files when a directory is given",
          event = "VimEnter",
          pattern = "*",
          command = function()
            local arg = vim.fn.argv()[1]
            if
              vim.fn.argc() == 1
              and vim.fn.isdirectory(arg) == 1
              and vim.fn.exists("s:std_in") ~= 1
            then
              require("mini.files").open(arg)
            end
          end,
        },
      })
    end,
    config = function(_, opts)
      local minifiles = require("mini.files")

      -- Functions to toggle hidden files
      local show_dotfiles = true
      local filter_show = function(_)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        minifiles.refresh({ content = { filter = new_filter } })
      end

      -- Create autocmds
      augroup("user_mini_files", {
        {
          desc = "Toggle hiding/revealing dotfiles",
          event = "User",
          pattern = "MiniFilesBufferCreate",
          command = function(e)
            local buf_id = e.data.buf_id
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
          end,
        },
        {
          desc = "Close mini.files on lost focus",
          event = "BufEnter",
          pattern = "*",
          command = function(_)
            local ft = vim.bo.filetype
            if ft == "minifiles" or ft == "minifiles-help" then
              return
            end
            local cur_win_id = vim.api.nvim_get_current_win()
            minifiles.close()
            pcall(vim.api.nvim_set_current_win, cur_win_id)
          end,
        },
        {
          desc = "Trigger lsp on rename",
          event = "User",
          pattern = "MiniFilesActionRename",
          command = function(e)
            require("utils.lsp").on_rename(e.data.from, e.data.to)
          end,
        },
      })

      -- Setup filter function
      opts.content = {
        filter = function(fs_entry)
          if show_dotfiles then
            return filter_show()
          else
            return filter_hide(fs_entry)
          end
        end,
      }

      -- Setup plugin
      minifiles.setup(opts)
    end,
  },
}
