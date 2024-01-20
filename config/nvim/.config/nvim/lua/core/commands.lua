local fn = vim.fn

vim.api.nvim_create_user_command(
  "Todo",
  [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]],
  {
    desc = "List todos in project",
  }
)

vim.api.nvim_create_user_command(
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

vim.api.nvim_create_user_command(
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

vim.api.nvim_create_user_command("ToggleList", function(args)
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
    require("utils.lib").notify("Location List is Empty.", vim.log.levels.ERROR)
    return
  end

  local winnr = fn.winnr()
  fn.execute(prefix .. "open")
  if fn.winnr() ~= winnr then
    vim.cmd([[wincmd p]])
  end
end, {
  desc = "Toggle quickfix or loclist",
  nargs = 1, -- {prefix(c=quickfix, l=loclist)}
})

vim.api.nvim_create_user_command("SystemOpen", function(args)
  local path = args.args and args.args or ""
  require("utils.cmd").sys_open(path)
end, {
  desc = "Open link/file under cursor",
  nargs = "?", -- {path?}
})

-- Change working directory
vim.api.nvim_create_user_command("Cwd", function()
  vim.cmd(":cd %:p:h")
  vim.cmd(":pwd")
end, { desc = "cd current file's directory" })

vim.api.nvim_create_user_command("ResizeWindow", function(args)
  local v = vim.api

  local d = args.args and args.args or "l"
  local lr = d == "l" or d == "r"
  -- 5 for left right, 3 for up down
  local amt = lr and 5 or 3

  local pos = v.nvim_win_get_position(0)
  local w = v.nvim_win_get_width(0)
  local h = v.nvim_win_get_height(0)
  if lr then
    amt = pos[2] == 0 and -amt or amt
  else
    amt = pos[1] == 0 and -amt or amt
  end
  w = (d == "l") and (w + amt) or (w - amt)
  h = (d == "u") and (h + amt) or (h - amt)

  if lr then
    v.nvim_win_set_width(0, w)
  else
    v.nvim_win_set_height(0, h)
  end
end, {
  desc = "Resize window in direction (l,d,u,r)",
  nargs = 1, -- {direction(l,d,u,r)}
})

vim.api.nvim_create_user_command("LspClients", function()
  local clients = require("utils.lsp").get_attached_clients()
  if next(clients) == nil then
    require("utils.lib").notify("No attached LSP servers", vim.log.levels.ERROR)
  end

  local lines = {}
  for s in vim.inspect(clients):gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  -- Show content in a reusable buffer
  local buf_id
  for _, id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[id].filetype == "user-lsp-clients-info" then
      buf_id = id
    end
  end
  if buf_id == nil then
    buf_id = vim.api.nvim_create_buf(true, true)
    vim.bo[buf_id].filetype = "user-lsp-clients-info"
  end
  -- Clear the buffer content
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, {})
  -- Append new text to the buffer
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  -- Open buffer in this window
  vim.api.nvim_win_set_buf(0, buf_id)
end, {
  desc = "Display attached lsp clients",
})
