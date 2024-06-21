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

return M
