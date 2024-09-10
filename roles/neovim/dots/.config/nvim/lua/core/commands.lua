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
    vim.notify("Location List is Empty.", vim.log.levels.ERROR)
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
  desc = "Open link/file (use empty path for whatever is under the cursor)",
  nargs = "?", -- {path?}
})

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

vim.api.nvim_create_user_command("SetDiagnosticMode", function(args)
  local mode = tonumber(args.args)
  if not mode then
    mode = vim.g.user_diagnostics_mode < #_G.user_diagnostics
        and vim.g.user_diagnostics_mode + 1
      or 0
  elseif mode < 0 or mode > #_G.user_diagnostics then
    vim.notify(
      "Provided mode MUST be a number between 0 and " .. #_G.user_diagnostics,
      vim.log.levels.ERROR
    )
    return
  end
  -- Set diagnotics based on mode
  vim.g.user_diagnostics_mode = mode
  vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])
end, {
  desc = "Set diagnostic mode (0-3)",
  nargs = "?", -- {mode(0-3)?}
})

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("bel 10new")
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer", nargs = 0 })

