return setmetatable({}, {
  __index = function(self, key)
    self[key] = require("utils." .. key)
    return self[key]
  end,
  reqcall = function(module)
    return setmetatable({}, {
      __index = function(_, k)
        return function(...)
          return require(module)[k](...)
        end
      end,
    })
  end,
})
