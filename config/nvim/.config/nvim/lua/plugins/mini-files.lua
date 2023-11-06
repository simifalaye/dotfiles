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
    opts = function()
      -- Setup show dotfiles toggle
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
        require("mini.files").refresh({ content = { filter = new_filter } })
      end
      augroup("user_mini_files", {
        {
          desc = "Toggle hiding/revealing dotfiles",
          event = "User",
          pattern = "MiniFilesBufferCreate",
          command = function(args)
            local buf_id = args.data.buf_id
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
            require("mini.files").close()
            pcall(vim.api.nvim_set_current_win, cur_win_id)
          end,
        },
      })
      return {
        -- Manual autocmd setup since netrw is disabled completely (in lazy.nvim)
        use_as_default_explorer = false,
        content = {
          filter = function(fs_entry)
            if show_dotfiles then
              return filter_show()
            else
              return filter_hide(fs_entry)
            end
          end,
        },
      }
    end,
  },
}
