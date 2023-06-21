return function(module)
  local ok, result = pcall(require, module)
  if ok then
    return result
  end
  return nil
end
