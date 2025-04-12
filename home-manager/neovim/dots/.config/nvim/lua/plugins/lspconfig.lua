-- Ex. local config to run clangd in docker container (.nlsp.json):
-- {
--   "clangd": {
--     "cmd": [
--       "docker",
--       "exec",
--       "--user",
--       "1000:1000",
--       "-i",
--       "-w",
--       "/working/build-PROD",
--       "myproj",
--       "/bin/sh",
--       "-c",
--       "/usr/bin/clangd --background-index --header-insertion=iwyu --offset-encoding=utf-16 --path-mappings /home/simifa/dev/myproj=/working/build-PROD,/home/simifa/dev/myproj/builddir/working/bazel=/working/bazel"
--     ]
--   }
-- }
_G.user_lspconfig_local_conf = _G.user_lspconfig_local_conf or {}

--- Get cached local lsp configuration or read from config file
---@param root_dir string
---@return table?
local function load_local_config(root_dir)
  local conf = _G.user_lspconfig_local_conf[root_dir]
  if conf then
    return conf
  end

  local conf_path = vim.fs.joinpath(root_dir, ".nlsp.json")
  if not require("utils.fs").file_exists(conf_path) then
    return nil
  end
  conf = require("utils.json").read(conf_path)
  _G.user_lspconfig_local_conf[root_dir] = conf
  return conf
end

return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "b0o/schemastore.nvim",
  --   },
  --   event = { "BufReadPre" },
  --   config = function()
  --     local lspconfig = require("lspconfig")
  --
  --     -- Register servers servers
  --     local server_configs = require("static.lsp")()
  --     for name, conf in pairs(server_configs) do
  --       if lspconfig[name] then
  --         local cmd = conf.cmd or lspconfig[name].document_config.default_config.cmd
  --         if not cmd or vim.fn.executable(cmd[1]) == 0 then
  --           conf.autostart = false
  --         end
  --         local on_new_config =
  --           lspconfig[name].document_config.default_config.on_new_config
  --         conf.on_new_config = function(new_config, new_root_dir)
  --           if on_new_config then
  --             on_new_config(new_config, new_root_dir)
  --           end
  --           local local_conf = load_local_config(new_root_dir)
  --           if not local_conf then
  --             return
  --           end
  --           -- Merge local conf with base conf
  --           local server_name = new_config.name
  --           if local_conf and local_conf[server_name] then
  --             -- Required to ensure original table variable is actually modified
  --             for k, v in
  --               pairs(vim.tbl_deep_extend("force", new_config, local_conf[server_name]))
  --             do
  --               new_config[k] = v
  --             end
  --           end
  --         end
  --         lspconfig[name].setup(conf)
  --       end
  --     end
  --   end,
  -- },
  {
    "TheRealLorenz/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "b0o/schemastore.nvim",
    },
  },
}
