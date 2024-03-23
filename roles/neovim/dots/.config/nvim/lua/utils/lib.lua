local M = {}

--- Wrapper around a module to require it before using any table members
---@param module string module to use
---@return table a metatable of the module
function M.reqcall(module)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(module)[k](...)
      end
    end,
  })
end

--- Serve a notification with a title of Nvim
---@param msg string The notification body
---@param level integer|nil The level of the notification (:help vim.log.levels)
function M.notify(msg, level)
  level = level or vim.log.levels.INFO
  if
    vim.g.user_notifications_enabled
    and (vim.g.user_log_level == nil or level >= vim.g.user_log_level)
  then
    vim.schedule(function()
      vim.notify(msg, level)
    end)
  end
end

--- Trigger an Nvim user event ("User <event>")
---@param event string The event name to be appended to NVim
function M.event(event)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "Core" .. event, modeline = false })
  end)
end

--- Convert a list or map into a value by transforming each field using a cb
---@generic T : table
---@param callback function(T, T, key: string | number): T
---@param list T[]
---@param accum T?
---@return T
function M.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

return M
