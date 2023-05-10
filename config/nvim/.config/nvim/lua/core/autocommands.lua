local api = vim.api
local cmd = vim.cmd
local timer = vim.loop.new_timer()
local command = require("utils.command")

command.augroup("user_file_utilities", {
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
      cmd([[ %s/\s\+$//e ]])
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
})

command.augroup("user_window_behaviours", {
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
    set = function ()
      vim.wo.cursorline = true
    end,
    command = function()
      if not timer then
        return
      end
      vim.wo.cursorlineopt = "number"
      timer:start(
        1000, -- default timeout
        0, vim.schedule_wrap(function() vim.wo.cursorlineopt = "both" end)
      )
    end,
  }
})

command.augroup("user_yank_text", {
  {
    desc = "Save cursor position whenever it moves",
    event = { "VimEnter", "CursorMoved" },
    pattern = "*",
    command = function()
      _G.cursor_pos = vim.fn.getpos(".")
    end,
  },
  {
    desc = "Highlight yanked text",
    event = "TextYankPost",
    pattern = "*",
    command = function()
      vim.highlight.on_yank({
        timeout = 400,
        on_visual = true,
        higroup = 'IncSearch',
      })
    end,
  },
  {
    desc = "Restore cursor position after yank",
    event = "TextYankPost",
    pattern = "*",
    command = function()
      if vim.v.event.operator == "y" then
        vim.fn.setpos(".", _G.cursor_pos)
      end
    end,
  },
})
