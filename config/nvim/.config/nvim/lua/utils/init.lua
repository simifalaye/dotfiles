local M = {}

M.path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

-- WSL deployment
M.is_wsl = (function()
  local uname = vim.fn.substitute(vim.fn.system("uname"), "\n", "", "")
  if uname == "Linux" then
    local s = string.match(vim.fn.readfile("/proc/version")[1], "microsoft")
    if s ~= nil and string.match(s, "microsoft") then
      return true
    end
    return false
  end
end)()

--- Covert a bool to a string
---@param bool boolean value
---@return string
M.bool2str = function(bool)
  return bool and "on" or "off"
end

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
M.extend_tbl = function(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Check if file exists
--- @param name string
M.file_exists = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

--- Join path segments based on os type
--- @vararg string
--- @return string
M.join_paths = function(...)
  local result = table.concat({ ... }, M.path_sep)
  return result
end

--- A helper function to wrap a module function to require a plugin before running
---@param plugin string The plugin to call `require("lazy").load` with
---@param module table The system module where the functions live (e.g. `vim.ui`)
---@param func_names string|string[] The functions to wrap in the given module (e.g. `{ "ui", "select }`)
function M.load_plugin_with_func(plugin, module, func_names)
  if type(func_names) == "string" then func_names = { func_names } end
  for _, func in ipairs(func_names) do
    local old_func = module[func]
    module[func] = function(...)
      module[func] = old_func
      require("lazy").load { plugins = { plugin } }
      module[func](...)
    end
  end
end

--- Serve a notification with a title of Nvim
---@param msg string The notification body
---@param type number|nil The type of the notification (:help vim.log.levels)
---@param opts? table The nvim-notify options to use (:help notify-options)
M.notify = function(msg, type, opts)
  local lvl = vim.g.user_log_level
  if not lvl or not type or type >= lvl then
    vim.schedule(function()
      vim.notify(msg, type, M.extend_tbl({ title = "Nvim" }, opts))
    end)
  end
end

--- Trigger an Nvim user event ("User <event>")
---@param event string The event name to be appended to NVim
M.event = function(event)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "Core" .. event, modeline = false })
  end)
end

--- Open a URL or file with system
---@param path string The path to the file or URL
M.system_open = function(path)
  local open = function(p)
    local cmd
    if M.is_wsl or (vim.fn.has("win32") == 1 and vim.fn.executable("explorer") == 1) then
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
      M.notify("Available system opening tool not found!", vim.log.levels.ERROR)
    end
    vim.fn.jobstart(vim.fn.extend(cmd, { p }), { detach = true })
  end

  path = path ~= "" and path or vim.fn.expand("<cfile>")
  if not path then
    return
  end

  if
    vim.fn.isdirectory(path) > 0 -- directory
    or vim.fn.filereadable(path) > 0 -- file
  then
    if M.is_wsl then
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
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
M.cmd = function(cmd, show_error)
  local wind32_cmd
  if vim.fn.has("win32") == 1 then
    wind32_cmd = { "cmd.exe", "/C", cmd }
  end
  local result = vim.fn.system(wind32_cmd or cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln(
      "Error running command: " .. cmd .. "\nError message:\n" .. result
    )
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

--- Convert a list or map into a value by transforming each field using a cb
---@generic T : table
---@param callback function(T, T, key: string | number): T
---@param list T[]
---@param accum T?
---@return T
M.fold = function(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

return M
