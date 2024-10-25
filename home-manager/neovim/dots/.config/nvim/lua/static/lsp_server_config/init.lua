local modules = require("utils.fs").get_lua_modules_in_directory(
  vim.fs.joinpath(
    vim.fn.stdpath("config") --[[@as string]],
    "lua",
    "static",
    "lsp_server_config"
  )
)

local flags = {
  debounce_text_changes = 150,
}
local default = { flags = flags }

local M = {}

local function get(name)
  local config_exists, config = pcall(require, "static.lsp_server_config." .. name)
  if not config_exists then
    config = vim.deepcopy(default)
  else
    config = vim.tbl_deep_extend("force", default, config)
  end
  return config
end

-- Metatable to dynamically require modules
setmetatable(M, {
  __index = function(_, key)
    return get(key)
  end,
  __call = function()
    local loaded_modules = {}
    for _, name in ipairs(modules) do
      loaded_modules[name] = get(name)
    end
    return loaded_modules
  end,
})

return M
