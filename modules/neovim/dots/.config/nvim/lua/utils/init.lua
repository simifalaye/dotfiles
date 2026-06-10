---@diagnostic disable: assign-type-mismatch

return setmetatable({
  fs = nil, ---@module 'utils.fs'
  git = nil, ---@module 'utils.git'
  hl = nil, ---@module 'utils.hl'
  json = nil, ---@module 'utils.json'
  ui = nil, ---@module 'utils.ui'
}, {
  __index = function(_, key)
    return require('utils.' .. key)
  end,
})
