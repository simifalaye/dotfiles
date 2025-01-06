local modules = require("utils.fs").get_lua_modules_in_directory(
  vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "lua", "static", "lsp")
)

local M = {}

local function get(name)
  local lsp = require("utils.lsp")
  local config_exists, config = pcall(require, "static.lsp." .. name)
  if not config_exists then
    config = vim.deepcopy(lsp.default_config)
  else
    if config.on_attach then
      local on_attach = config.on_attach
      config.on_attach = function(client, bufnr)
        -- Load default on_attach
        lsp.default_config.on_attach(client, bufnr)
        -- Override with user on_attach
        on_attach(client, bufnr)
      end
    end
    config = vim.tbl_deep_extend("force", lsp.default_config, config)
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
