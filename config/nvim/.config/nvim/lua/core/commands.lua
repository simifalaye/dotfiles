local api = vim.api
local fn = vim.fn
local utils = require("utils")
local timer = vim.loop.new_timer()
local augroup = require("utils.command").augroup
local command = require("utils.command").command

--------------------------------------------------------------------------------
--  Autocommands
--------------------------------------------------------------------------------

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
    pattern = "*",
    command = function()
      vim.highlight.on_yank({
        timeout = 400,
        on_visual = true,
        higroup = "IncSearch",
      })
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

--------------------------------------------------------------------------------
--  User Commands
--------------------------------------------------------------------------------

command("Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]], {
  desc = "List todos in project",
})

command(
  "MoveWrite",
  -- source: https://superuser.com/a/540519
  [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]],
  {
    desc = "Move visual selection to a file (overwrite)",
    bang = true,
    range = true,
    complete = "file",
    nargs = 1, -- Selection
  }
)

command(
  "MoveAppend",
  -- source: https://superuser.com/a/540519
  [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]],
  {
    desc = "Move visual selection to a file (append)",
    bang = true,
    range = true,
    complete = "file",
    nargs = 1, -- Selection
  }
)

command("ToggleList", function(args)
  local prefix = args.args
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      fn.execute(prefix .. "close")
      return
    end
  end
  if prefix == "l" and vim.tbl_isempty(fn.getloclist(0)) then
    utils.notify("Location List is Empty.", vim.log.levels.ERROR)
    return
  end

  local winnr = fn.winnr()
  fn.execute(prefix .. "open")
  if fn.winnr() ~= winnr then
    vim.cmd([[wincmd p]])
  end
end, {
  desc = "Toggle quickfix or loclist",
  nargs = 1, -- {prefix(c=quickfix, l=loclist}
})

command("SystemOpen", function(args)
  local path = args.args and args.args or ""
  utils.system_open(path)
end, {
  desc = "Open link/file under cursor",
  nargs = "?", -- {path?}
})

-- Change working directory
command("Cwd", function()
  vim.cmd(":cd %:p:h")
  vim.cmd(":pwd")
end, { desc = "cd current file's directory" })
