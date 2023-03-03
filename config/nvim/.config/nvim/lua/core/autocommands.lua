local api = vim.api
local cmd = vim.cmd
local command = require("utils.command")

command.augroup("Utilities", {
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

command.augroup("WindowBehaviours", {
  {
    desc = "Jump to quickfix window when opened",
    event = { "QuickFixCmdPost" },
    pattern = { "[^l]*" },
    command = "cwindow",
    nested = true,
  },
  {
    desc = "Jump to loclist window when opened",
    event = { "QuickFixCmdPost" },
    pattern = { "l*" },
    command = "lwindow",
    nested = true,
  },
  {
    desc = "Auto-resize splits",
    event = { "VimResized" },
    pattern = { "*" },
    command = "wincmd =",
  },
  {
    desc = "Highlight window when focused",
    event = { "BufEnter", "WinEnter", "InsertLeave" },
    pattern = "*",
    command = function()
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
    end,
  },
  {
    desc = "Un-highlight window when un-focused",
    event = { "BufLeave", "WinLeave", "InsertEnter" },
    pattern = "*",
    command = function()
      vim.opt.relativenumber = false
      vim.opt.cursorline = false
    end,
  },
})

command.augroup("YankText", {
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
