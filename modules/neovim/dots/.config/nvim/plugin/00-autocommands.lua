local file_utilities_grp = vim.api.nvim_create_augroup("user_file_utilities", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = file_utilities_grp,
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local ignore = { "ruby", "perl", "markdown", "gitsendemail", "gitcommit" }
    for _, val in ipairs(ignore) do
      if string.match(ft, val) then
        return
      end
    end
    vim.cmd([[ %s/\s\+$//e ]])
  end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to last known position and center buffer around cursor",
  group = file_utilities_grp,
  pattern = "*",
  callback = function(event)
    local exclude = { "gitcommit", "popup" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
      return
    end
    vim.b[buf].user_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed",
  group = file_utilities_grp,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("silent! checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  desc = "Ensure proper 'formatoptions'",
  group = file_utilities_grp,
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd("setlocal formatoptions-=c formatoptions-=o")
  end,
})

local window_behaviours_grp = vim.api.nvim_create_augroup("user_window_behaviours", {})
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto-resize splits",
  group = window_behaviours_grp,
  pattern = { "*" },
  command = "tabdo wincmd =",
})

local yank_text_grp = vim.api.nvim_create_augroup("user_yank_text", {})
vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
  desc = "Save cursor position whenever it moves",
  group = yank_text_grp,
  pattern = "*",
  callback = function()
    vim.g.user_cursor_pos = vim.fn.getpos(".")
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = yank_text_grp,
  callback = function()
    vim.highlight.on_yank({ timeout = 200, higroup = "IncSearch" })
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Restore cursor position after yank",
  group = yank_text_grp,
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setpos(".", vim.g.user_cursor_pos)
    end
  end,
})

local ft_corrections_grp = vim.api.nvim_create_augroup("user_ft_corrections", {})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set dockerfile",
  group = ft_corrections_grp,
  pattern = "Dockerfile*",
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})
