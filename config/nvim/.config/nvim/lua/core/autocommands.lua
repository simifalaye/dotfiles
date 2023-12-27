local api = vim.api
local timer = vim.loop.new_timer()
local augroup = require("utils.augroup")

augroup("user_file_utilities", {
  {
    desc = "Remove trailing whitespace on save",
    event = "BufWritePre",
    pattern = "*",
    command = function()
      local ft = vim.bo.filetype
      local ignore = { "ruby", "perl", "markdown", "gitsendemail", "gitcommit" }
      for _, val in ipairs(ignore) do
        if string.match(ft, val) then
          return
        end
      end
      vim.cmd([[ %s/\s\+$//e ]])
    end,
  },
  {
    desc = "Jump to last known position and center buffer around cursor",
    event = "BufReadPost",
    pattern = "*",
    command = function()
      if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
        local last_place_mark = api.nvim_buf_get_mark(0, '"')
        local line_nr = last_place_mark[1]
        local last_line = api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= last_line then
          api.nvim_win_set_cursor(0, last_place_mark)
        end
      end
    end,
  },
  {
    desc = "Use mkdir -p when writing file path that doesn't exist",
    event = { "BufWritePre", "FileWritePre" },
    pattern = "*",
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    desc = "Set settings for large files.",
    event = { "BufReadPre" },
    command = function(info)
      if vim.b.large_file ~= nil then
        return
      end
      vim.b.large_file = false
      local ok, stat = pcall(vim.loop.fs_stat, info.match)
      if ok and stat and stat.size > 1000000 then
        vim.b.large_file = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.statuscolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.winbar = ""
        vim.api.nvim_create_autocmd("BufReadPost", {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.opt_local.syntax = ""
            return true
          end,
        })
      end
    end,
  },
})

augroup("user_window_behaviours", {
  {
    desc = "Auto-resize splits",
    event = { "VimResized" },
    pattern = { "*" },
    command = "tabdo wincmd =",
  },
  {
    desc = "Show cursorline when focused",
    event = { "WinEnter" },
    command = function()
      vim.wo.cursorline = true
    end,
  },
  {
    desc = "Hide cursorline when un-focused",
    event = { "WinLeave" },
    command = function()
      vim.wo.cursorline = false
    end,
  },
  {
    desc = "Show cursorline when cursor is not moved for some time",
    event = { "CursorMoved", "CursorMovedI" },
    command = function()
      if not timer then
        return
      end
      vim.wo.cursorlineopt = "number"
      timer:start(
        1000, -- default timeout
        0,
        vim.schedule_wrap(function()
          vim.wo.cursorlineopt = "both"
        end)
      )
    end,
  },
})

augroup("user_yank_text", {
  {
    desc = "Save cursor position whenever it moves",
    event = { "VimEnter", "CursorMoved" },
    pattern = "*",
    command = function()
      vim.g.user_cursor_pos = vim.fn.getpos(".")
    end,
  },
  {
    desc = "Highlight yanked text",
    event = "TextYankPost",
    command = function()
      vim.highlight.on_yank({ timeout = 200, higroup = "IncSearch" })
    end,
  },
  {
    desc = "Restore cursor position after yank",
    event = "TextYankPost",
    pattern = "*",
    command = function()
      if vim.v.event.operator == "y" then
        vim.fn.setpos(".", vim.g.user_cursor_pos)
      end
    end,
  },
})

augroup("user_auto_cwd", {
  {
    desc = "Automatically change local current directory.",
    event = { "BufWinEnter", "FileChangedShellPost" },
    pattern = "*",
    command = function(info)
      vim.schedule(function()
        if
          info.file == ""
          or not vim.api.nvim_buf_is_valid(info.buf)
          or vim.bo[info.buf].bt ~= ""
          or (vim.loop.fs_stat(info.file) or {}).type ~= "file"
        then
          return
        end
        local current_dir = vim.fn.getcwd(0)
        local target_dir = require("utils.fs").proj_dir(info.file)
          or vim.fs.dirname(info.file)
        local stat = target_dir and vim.loop.fs_stat(target_dir)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if current_dir ~= target_dir and stat and stat.type == "directory" then
          vim.cmd.lcd(target_dir)
        end
      end)
    end,
  },
})