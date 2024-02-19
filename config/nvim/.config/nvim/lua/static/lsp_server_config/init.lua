local flags = {
  debounce_text_changes = 150,
}
local default = { flags = flags }

return setmetatable({}, {
  __index = function(self, key)
    local config_exists, config = pcall(require, "static.lsp_server_config." .. key)
    if not config_exists then
      config = vim.deepcopy(default)
    else
      config = vim.tbl_deep_extend("force", default, config)
    end
    self[key] = config
    return config
  end,
})
