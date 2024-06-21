local global_ts = "/usr/local/lib/node_modules/typescript/lib"
local function get_typescript_server_path(root_dir)
  local fs = require("utils.fs")
  local proj_ts = vim.fs.joinpath(root_dir, "node_modules", "typescript", "lib")
  if fs.dir_exists(proj_ts) then
    return proj_ts
  end
  return global_ts
end

return {
  -- Enable volar takeover mode (use volar to replace tsserver)
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "json",
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}
