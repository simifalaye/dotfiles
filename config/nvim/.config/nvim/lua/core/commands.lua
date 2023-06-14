local api = vim.api
local fn = vim.fn
local log = require("utils.log")

api.nvim_create_user_command(
  "Todo",
  [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]],
  {
    desc = "List todos in project",
  }
)

api.nvim_create_user_command(
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

api.nvim_create_user_command(
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

api.nvim_create_user_command("ToggleList", function(opt)
  local prefix = opt.args
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
    log.warn("Location List is Empty.")
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

api.nvim_create_user_command("OpenLink", function(opt)
  local open = function(path)
    local cmd
    if
      _G.is_wsl
      or (vim.fn.has("win32") == 1 and vim.fn.executable("explorer") == 1)
    then
      cmd = { "explorer.exe" }
    elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
      cmd = { "xdg-open" }
    elseif
      (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1)
      and vim.fn.executable("open") == 1
    then
      cmd = { "open" }
    end
    if not cmd then
      vim.notify(
        "Available system opening tool not found!",
        vim.log.levels.ERROR
      )
    end
    vim.fn.jobstart(vim.fn.extend(cmd, { path }), { detach = true })
  end

  local path = (opt.args and opt.args ~= "") and opt.args
    or fn.expand("<cfile>")
  if not path then
    return
  end

  if
    fn.isdirectory(path) > 0 -- directory
    or fn.filereadable(path) > 0 -- file
  then
    if _G.is_wsl then
      path = vim.fn.system("wslpath -w " .. path)
    end
    return open(path)
  elseif path:match("http[s]?://") then -- link
    return open(path)
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
  local link = string.match(path, plugin_url_regex)
  if link then
    return open(string.format("https://www.github.com/%s", link))
  end
end, {
  desc = "Open link under cursor",
  nargs = "?", -- {path?}
})

api.nvim_create_user_command("SetMinLogLevel", function(opt)
  vim.env.NVIM_MIN_LOG_LEVEL = opt.args
  log.new({}, true)
end, {
  desc = "Set minimum log level: trace, debug, info, warn, error, fatal",
  nargs = 1, -- {level}
})
