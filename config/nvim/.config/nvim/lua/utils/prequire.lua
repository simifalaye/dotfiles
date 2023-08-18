--- Attempt requiring a module. Return nil if it doesn't exist
---@param module string
---@return table|nil
return function(module)
  local ok, result = pcall(require, module)
  if ok then
    return result
  end
  return nil
end
