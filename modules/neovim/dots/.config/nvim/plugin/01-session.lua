--
-- Session Manager that handles terminal buffers how I would like
-- When switching sessions in the same neovim instance, don't kill terminal buffers
-- but pin them to the session so you can switch back and forth between sessions
-- while keeping terminals running
--

if vim.g.loaded_user_plugin_session then
  return
end
vim.g.loaded_user_plugin_session = true

---@class SessionOpts
---@field disabled boolean
---@field autowrite boolean
---@field dir string
---@field force {read: boolean, write: boolean, delete: boolean}

---@type SessionOpts
local default_config = {
  disabled = false,
  autowrite = true,
  dir = vim.fs.joinpath(vim.fn.stdpath("data"), "session"),
  force = { read = false, write = true, delete = true },
}

---@type SessionOpts | fun():SessionOpts
vim.g.session = vim.g.session

--- Get configuration
---@return SessionOpts
local function get_config()
  local opts = type(vim.g.session) == "function" and vim.g.session()
    or vim.g.session
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- State
--

local current_session
local existing_terminals = {}

--
-- Utilities
--

--- Get the path for a session file based on the name
---@param name string
---@return string
local function session_path(name)
  local config = get_config()
  return vim.fs.joinpath(config.dir, name .. ".vim")
end

--- Get the name of a session based on the path
---@param path string
---@return string
local function session_name(path)
  local name, _ = vim.fs.basename(path):gsub("%.vim$", "")
  return name
end

--- Check if a session exists
---@param name string
---@return boolean
local function session_exists(name)
  return vim.fn.filereadable(session_path(name)) == 1
end

---@class SessionMetadata
---@field name string
---@field path string
---@field modify_time integer

--- List available sessions
---@param exclude_current boolean?
---@return SessionMetadata[]
local function list_sessions(exclude_current)
  exclude_current = exclude_current or false
  local ret = {}
  local config = get_config()

  local fd = vim.uv.fs_opendir(config.dir, nil, 100)
  if not fd then
    return ret
  end

  while true do
    local entries = vim.uv.fs_readdir(fd)
    if not entries then
      break
    end
    for _, entry in ipairs(entries) do
      if entry.type == "file" then
        local name = session_name(entry.name)
        if name then
          local path = session_path(name)
          if not exclude_current or path ~= current_session then
            table.insert(ret, {
              name = name,
              path = path,
              modify_time = vim.fn.getftime(path),
            })
          end
        end
      end
    end
  end

  vim.uv.fs_closedir(fd)

  table.sort(ret, function(a, b)
    return a.modify_time > b.modify_time
  end)

  return ret
end

--- Close entire layout and buffers (except terminal buffers)
local function close_everything()
  local is_floating_win = vim.api.nvim_win_get_config(0).relative ~= ""
  if is_floating_win then
    -- Go to the first window, which will not be floating
    vim.cmd.wincmd({ args = { "w" }, count = 1 })
  end

  local scratch = vim.api.nvim_create_buf(false, true)
  vim.bo[scratch].bufhidden = "hide"
  vim.api.nvim_win_set_buf(0, scratch)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      if vim.bo[buf].buftype == "terminal" then
        vim.bo[buf].bufhidden = "hide"
        vim.bo[buf].buflisted = false
        local name = vim.api.nvim_buf_get_name(buf)
        existing_terminals[name] = buf
      else
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end
  vim.cmd.tabonly({ mods = { emsg_silent = true } })
  vim.cmd.only({ mods = { emsg_silent = true } })
end

--- Replace any placeholder terminal buffers created by 'sessionoptions+terminal'
--- with the real existing terminal buffer if it exists
local function replace_terminal_placeholders()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      local name = vim.api.nvim_buf_get_name(buf)
      local real = existing_terminals[name]

      if real and not vim.api.nvim_buf_is_valid(real) then
        existing_terminals[name] = nil
        real = nil
      end

      if real and real ~= buf then
        vim.bo[real].buflisted = true
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_win_set_buf(win, real)
          end
        end
        vim.api.nvim_buf_delete(buf, {
          force = true,
        })
      end
    end
  end
end

--
-- API
--

local M = {}

--- Wipe the layout to start a new session
function M.wipe_layout()
  close_everything()
end

--- Check if session exists
---@param name string
---@return boolean
function M.exists(name)
  return session_exists(name)
end

--- List available sessions
---@return SessionMetadata[]
function M.list()
  return list_sessions()
end

--- Get current session
---@return string|nil
function M.current()
  return current_session
end

--- Rename a session
---@param old string
---@param new string
function M.rename(old, new)
  if old == "" then
    error("Old session name cannot be empty")
  end
  if new == "" then
    error("New session name cannot be empty")
  end

  local old_path = session_path(old)
  local old_path_stat = vim.uv.fs_stat(old_path)
  if not old_path_stat or old_path_stat.type ~= "file" then
    error(string.format("Session '%s' does not exist", old))
  end

  local new_path = session_path(new)
  local ok, err =
    vim.fn.rename(vim.fn.fnameescape(old_path), vim.fn.fnameescape(new_path))
  if not ok then
    error(err)
  end

  if current_session == old then
    current_session = new
    vim.v.this_session = new_path
  end
end

--- Write a session
---@param name string
function M.write(name)
  local config = get_config()
  if config.disabled then
    return
  end

  if name == "" then
    error("Must provide a session name")
  end

  local path = session_path(name)
  local path_readable = vim.fn.isdirectory(path) ~= 1
    and vim.fn.getfperm(path):sub(1, 1) == "r"
  if not config.force.write and path_readable then
    error("Can't write to existing session when `config.force.write` is not `true`")
  end
  vim.cmd(
    string.format(
      "mksession%s %s",
      config.force.write and "!" or "",
      vim.fn.fnameescape(path)
    )
  )

  current_session = name
  vim.v.this_session = path
end

--- Load a session
---@param name string
function M.read(name)
  local config = get_config()
  if config.disabled then
    return
  end

  if name == "" then
    error("Session name cannot be empty")
  end
  if not session_exists(name) then
    error("Session does not exist: " .. name)
  end

  -- Possibly check for unsaved listed buffers and do nothing if present
  if not config.force.read then
    local unsaved_listed_buffers = vim.tbl_filter(function(buf_id)
      return vim.bo[buf_id].modified and vim.bo[buf_id].buflisted
    end, vim.api.nvim_list_bufs())
    if #unsaved_listed_buffers > 0 then
      local buf_list = table.concat(unsaved_listed_buffers, ", ")
      error(("There are unsaved listed buffers: %s."):format(buf_list))
    end
  end

  if config.autowrite and current_session then
    M.write(current_session)
  end

  close_everything()

  local path = session_path(name)
  current_session = name
  vim.v.this_session = path
  vim.cmd.source(vim.fn.fnameescape(path))

  vim.schedule(function()
    replace_terminal_placeholders()
  end)
end

--- Delete a session
---@param name string
function M.delete(name)
  local config = get_config()
  if config.disabled then
    return
  end

  if name == "" then
    error("Session name cannot be empty")
  end
  if not session_exists(name) then
    error("Session does not exist: " .. name)
  end

  local path = session_path(name)
  if not config.force.delete and path == vim.v.this_session then
    error("Can't delete current session when `config.force.delete` is not `true`.")
  end

  if vim.fn.delete(path) ~= 0 then
    error("Failed to delete session")
  end

  if current_session == name then
    current_session = nil
    vim.v.this_session = ""
  end
end

-- Export module
_G.Session = M

--
-- Main
--

local config = get_config()

vim.fn.mkdir(config.dir, "p")

local function with_error_notify(fn, success_fn)
  return function(...)
    local ok, result = pcall(fn, ...)
    if not ok then
      vim.notify(result, vim.log.levels.ERROR)
      return nil
    end
    if success_fn then
      success_fn(...)
    end
    return result
  end
end

local complete_sessions = function()
  return vim.tbl_map(function(item)
    return item.name
  end, M.list())
end

-- Autocommands
local augroup = vim.api.nvim_create_augroup("user.plugin.session", { clear = false })
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Autowrite current session",
  group = augroup,
  callback = function(_)
    if config.autowrite and current_session then
      M.write(current_session)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWipeout", {
  desc = "Clean session terminals cache",
  group = augroup,
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if existing_terminals[name] == args.buf then
      existing_terminals[name] = nil
    end
  end,
})

-- Commands
vim.api.nvim_create_user_command("SessionCurrent", function(_)
  local current = M.current()
  if not current then
    vim.notify("Not currently in an active session")
    return
  end
  print(current)
end, {
  desc = "Show current session",
})
vim.api.nvim_create_user_command("SessionRename", function(opts)
  local args = opts.fargs
  local call = with_error_notify(M.rename, function(old, new)
    vim.notify(string.format("Renamed session from '%s' to '%s'", old, new))
  end)

  local function prompt_new(old)
    vim.ui.input({
      prompt = "New name: ",
    }, function(value)
      if value and value ~= "" then
        call(old, value)
      end
    end)
  end

  if #args == 0 then
    local sessions = list_sessions()
    if vim.tbl_isempty(sessions) then
      vim.notify("No saved sessions", vim.log.levels.ERROR)
      return
    end
    vim.ui.select(sessions, {
      prompt = "Read session",
      format_item = function(item)
        return item.name
      end,
    }, function(value)
      if value then
        if value == "" then
          local current = M.current()
          if current == nil then
            vim.notify(
              "Old name cannot be empty if not in a session",
              vim.log.levels.ERROR
            )
            return
          end
          value = current
        end
        prompt_new(value)
      end
    end)
  elseif #args == 1 then
    prompt_new(args[1])
  elseif #args == 2 then
    call(args[1], args[2])
  else
    vim.notify("Expect at most 2 args: old, new", vim.log.levels.ERROR)
  end
end, {
  nargs = "*",
  complete = complete_sessions,
  desc = "Write a session",
})
vim.api.nvim_create_user_command("SessionWrite", function(opts)
  local call = with_error_notify(M.write, function(name)
    vim.notify(string.format("Wrote session: %s", name))
  end)
  if opts.args == "" and current_session == nil then
    vim.ui.input({
      prompt = "Session name: ",
    }, function(value)
      if value or value ~= "" then
        call(value)
      end
    end)
  else
    call(opts.args)
  end
end, {
  nargs = "?",
  complete = complete_sessions,
  desc = "Write a session",
})
vim.api.nvim_create_user_command("SessionRead", function(opts)
  local call = with_error_notify(M.read, function(name)
    vim.notify(string.format("Read session: %s", name))
  end)
  if opts.args == "" then
    local sessions = list_sessions(true)
    if vim.tbl_isempty(sessions) then
      vim.notify("No other saved sessions", vim.log.levels.ERROR)
      return
    end
    vim.ui.select(sessions, {
      prompt = "Read session",
      format_item = function(item)
        return item.name
      end,
    }, function(value)
      if value and value ~= "" then
        call(value.name)
      end
    end)
  else
    call(opts.args)
  end
end, {
  nargs = "?",
  complete = complete_sessions,
  desc = "Read a session",
})
vim.api.nvim_create_user_command("SessionDelete", function(opts)
  local call = with_error_notify(M.delete, function(name)
    vim.notify(string.format("Deleted session: %s", name))
  end)
  if opts.args == "" then
    local sessions = list_sessions(false)
    if vim.tbl_isempty(sessions) then
      vim.notify("No saved sessions", vim.log.levels.ERROR)
      return
    end

    vim.ui.select(sessions, {
      prompt = "Delete session",
      format_item = function(item)
        return item.name
      end,
    }, function(value)
      if value and value ~= "" then
        call(value.name)
      end
    end)
  else
    call(opts.args)
  end
end, {
  nargs = "?",
  complete = complete_sessions,
  desc = "Delete a session",
})

-- Keymaps
vim.keymap.set("n", "<leader>qc", "<cmd>SessionCurrent<CR>", { desc = "Current Session" })
vim.keymap.set("n", "<leader>qd", "<cmd>SessionDelete<CR>", { desc = "Delete Session" })
vim.keymap.set("n", "<leader>qr", "<cmd>SessionRead<CR>", { desc = "Read Session" })
vim.keymap.set("n", "<leader>qw", "<cmd>SessionWrite<CR>", { desc = "Write Session" })
