local uv = vim.loop
local M = {}

M.path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

M.root_patterns = {
  ".git/",
  ".svn/",
  ".bzr/",
  ".hg/",
  ".project/",
  ".marksman.toml",
  ".pro",
  ".sln",
  ".vcxproj",
  "Makefile",
  "makefile",
  "MAKEFILE",
  ".gitignore",
  ".editorconfig",
}

--- Check if file exists
--- @param name string
function M.file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function M.basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

function M.remove_slash(str)
  if str:sub(-1) == "/" then
    return str:sub(1, -2)
  else
    return str
  end
end

--- Join path segments based on os type
--- @vararg string
--- @return string
function M.join_paths(...)
  local result = table.concat({ ... }, M.path_sep)
  return result
end

---Compute project directory for given path.
---@param path string?
---@param patterns string[]? root patterns
---@return string? nil if not found
function M.proj_dir(path, patterns)
  if not path or path == "" then
    path = vim.fn.expand("%:p")
  end
  patterns = patterns or M.root_patterns
  ---@diagnostic disable-next-line: undefined-field
  local stat = vim.loop.fs_stat(path)
  if not stat then
    return
  end
  local dirpath = stat.type == "directory" and path or vim.fs.dirname(path)
  for _, pattern in ipairs(patterns) do
    local root = vim.fs.find(pattern, {
      path = dirpath,
      upward = true,
      type = pattern:match("/$") and "directory" or "file",
    })[1]
    if root and vim.loop.fs_stat(root) then
      local dirname = vim.fs.dirname(root)
      return dirname and vim.loop.fs_realpath(dirname) --[[@as string]]
    end
  end
end

---Read file contents
---@param path string
---@return string?
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content or ""
end

---Write string into file
---@param path string
---@return boolean success
function M.write_file(path, str)
  local file = io.open(path, "w")
  if not file then
    return false
  end
  file:write(str)
  file:close()
  return true
end

local make_default_error_cb = function(path, runnable)
  return function(error, _)
    error(
      "fwatch.watch("
        .. path
        .. ", "
        .. runnable
        .. ")"
        .. "encountered an error: "
        .. error
    )
  end
end

function M.watch_with_function(path, on_event, on_error, opts)
  -- TODO: Check for 'fail'? What is 'fail' in the context of handle creation?
  --       Probably everything else is on fire anyway (or no inotify/etc?).
  local handle = uv.new_fs_event()

  -- these are just the default values
  local flags = {
    watch_entry = false, -- true = when dir, watch dir inode, not dir content
    stat = false, -- true = don't use inotify/kqueue but periodic check, not implemented
    recursive = false, -- true = watch dirs inside dirs
  }

  local unwatch_cb = function()
    uv.fs_event_stop(handle)
  end

  local event_cb = function(err, filename, events)
    if err then
      on_error(error, unwatch_cb)
    else
      on_event(filename, events, unwatch_cb)
    end
    if opts and opts.is_oneshot then
      unwatch_cb()
    end
  end

  -- attach handler
  uv.fs_event_start(handle, path, flags, event_cb)

  return handle
end

-- @doc """
-- Watch a path and run given string as an ex command
--
-- Internally creates on_event and on_error handler and
-- delegates to watch_with_function.
--
-- """
function M.watch_with_string(path, string, opts)
  local on_event = function(_, _)
    vim.schedule(function()
      vim.cmd(string)
    end)
  end
  local on_error = make_default_error_cb(path, string)
  return M.watch_with_function(path, on_event, on_error, opts)
end

-- @doc """
-- Sniff parameters and call appropriate watch handler
-- """
function M.watch(path, runnable, opts)
  if type(runnable) == "string" then
    return M.watch_with_string(path, runnable, opts)
  elseif type(runnable) == "table" then
    assert(runnable.on_event, "must provide on_event to watch")
    assert(type(runnable.on_event) == "function", "on_event must be a function")

    -- no on_error provided, make default
    if runnable.on_error == nil then
      table.on_error = make_default_error_cb(path, "on_event_cb")
    end

    return M.watch_with_function(path, runnable.on_event, runnable.on_error, opts)
  else
    error(
      "Unknown runnable type given to watch,"
        .. " must be string or {on_event = function, on_error = function}."
    )
  end
end

return M
