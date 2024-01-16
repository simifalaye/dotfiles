-- Only load if not already loaded
if vim.g.loaded_user_plugin_docker_dev then
  return
end
vim.g.loaded_user_plugin_docker_dev = true

local prequire = require("utils.prequire")
local fs = require("utils.fs")
local json = require("utils.json")
local lib = require("utils.lib")
local lsp = require("utils.lsp")
local user_cfgs = {}
local client_cfgs = {}

-- Constants
DOCKER_DEV_FILE = ".docker-dev.json"
PROJECT_ROOT_PLACEHOLDER = "{{project_root}}"

-- Example configuration (.docker-dev.json)
-- {
--   "container_name": "my_cpp_app",
--   "container_workdir": "/src",
--   "container_setup_cmd": "sudo apt update && sudo apt install -y clangd && wget -O /tmp/bcc.deb https://github.com/kiron1/bazel-compile-commands/releases/download/v0.8.2/bazel-compile-commands_0.8.2_amd64.deb && sudo dpkg -i /tmp/bcc.deb",
--   "container_ready_cmd": "which clangd",
--   "container_uid": 0,
--   "container_gid": 0,
--   "image_name": "my_cpp_app_image",
--   "lsp_client_name": "clangd",
--   "lsp_client_cmd": "/usr/bin/clangd --log=verbose --background-index --header-insertion=iwyu --offset-encoding=utf-16 --path-mappings {{project_root}}=/src",
--   "mounts": [
--     "{{project_root}}:/src"
--   ],
--   "editor_cmds": [
--     {
--       "name": "CCGenerate",
--       "desc": "Generate/refresh compile_commands file",
--       "cmd": "bazel-compile-commands -v -s '--output_user_root=/working/bazel' -b '--compilation_mode=opt' -b '--config=prod' //src/... //test/ut/..."
--       "restart_lsp": true,
--     }
--   ]
-- }

--- Validate a docker dev config
---@param conf table
---@return boolean true if successfully validated
local function validate_conf(conf)
  local default_uid = tonumber(vim.fn.expand("$UID"))
  local default_gid = tonumber(vim.fn.expand("$GID"))
  for _, v in ipairs({
    { name = "container_name", type = "string" },
    { name = "container_workdir", type = "string", default = "/app" },
    { name = "container_setup_cmd", type = "string", default = "echo 'Done'" },
    { name = "container_ready_cmd", type = "string", default = "return 0" },
    {
      name = "container_uid",
      type = "number",
      default = default_uid and default_uid or 0,
    },
    {
      name = "container_gid",
      type = "number",
      default = default_gid and default_gid or 0,
    },
    { name = "image_name", type = "string" },
    { name = "lsp_client_name", type = "string" },
    { name = "lsp_client_cmd", type = "string" },
    { name = "mounts", type = "table", default = {} },
    { name = "editor_cmds", type = "table", default = {} },
  }) do
    if not conf[v.name] and v.default then
      conf[v.name] = v.default
    end
    if not conf[v.name] or type(conf[v.name]) ~= v.type then
      vim.schedule(function()
        lib.notify(
          string.format(
            "Docker-dev: key '%s' missing or unexpected type (%s)",
            v.name,
            v.type
          ),
          vim.log.levels.ERROR
        )
      end)
      return false
    end
  end
  -- Validate individual mount entries
  for _, v in ipairs(conf.mounts) do
    if type(v) ~= "string" then
      vim.schedule(function()
        lib.notify(
          "All mounts must be a string of the form 'local_path:remote_path'",
          vim.log.levels.ERROR
        )
      end)
      return false
    end
  end
  -- Validate individual editor_cmds entries
  for k, v in ipairs(conf.editor_cmds) do
    if
      not v.name
      or type(v.name) ~= "string"
      or not v.desc
      or type(v.desc) ~= "string"
      or not v.cmd
      or type(v.cmd) ~= "string"
    then
      vim.schedule(function()
        lib.notify(
          "All editor_cmds must be a table containing a name, desc and cmd field (all strings)",
          vim.log.levels.ERROR
        )
      end)
      return false
    end
    conf.editor_cmds[k].restart_lsp = v.restart_lsp or false
  end
  return true
end

--- Replace placeholders in string values with actual values
---@param conf table
local function replace_placeholders(conf, root_dir)
  local function repl(v)
    return v:gsub(PROJECT_ROOT_PLACEHOLDER, root_dir)
  end

  for k, v in pairs(conf) do
    if type(v) == "string" then
      conf[k] = repl(v)
    elseif type(v) == "table" then
      for k_, v_ in ipairs(v) do
        if type(v_) == "string" then
          conf[k][k_] = repl(v_)
        end
      end
    end
  end
end

--- Setup the container for the docker dev config
---@param root_dir string the root directory of the project
---@return boolean
local function setup_container(root_dir)
  if not user_cfgs[root_dir] or not user_cfgs[root_dir].conf then
    lib.notify(
      "Missing or incomplete docker-dev config for root: " .. root_dir,
      vim.log.levels.DEBUG
    )
    return false
  end
  if user_cfgs[root_dir].started then
    lib.notify("Container already started for root: " .. root_dir, vim.log.levels.DEBUG)
    return true
  end

  -- Disable lsp autostart since we will be starting the client manually
  lsp.autostart = false

  local conf = user_cfgs[root_dir].conf

  -- Construct build mounts option
  local mounts = {}
  for _, v in ipairs(conf.mounts) do
    local src, tar = v:match("([^:]+):([^:]+)")
    table.insert(mounts, { type = "bind", source = src, target = tar })
  end

  -- Start container
  if
    not lsp.dev_container_setup(conf.container_name, conf.image_name, {
      uid = conf.container_uid,
      gid = conf.container_gid,
      cmd = conf.container_setup_cmd,
      mounts = mounts,
    })
  then
    return false
  end

  -- Wait till the dev container is ready and modify the lsp config
  lsp.dev_container_wait(conf.container_name, conf.container_ready_cmd, {
    uid = conf.container_uid,
    gid = conf.container_gid,
    cb = function()
      -- Check dependencies
      local lspconfig = prequire("lspconfig")
      if
        not lspconfig
        or not client_cfgs[conf.lsp_client_name]
        or not client_cfgs[conf.lsp_client_name].cmds
      then
        return
      end

      local server_conf = require("static.lsp-servers")[conf.lsp_client_name]
      local default_cmd = lspconfig[conf.lsp_client_name].cmd

      -- Configure lsp client only once
      if not client_cfgs[conf.lsp_client_name].configured then
        -- Setup config with lspconfig
        local default_on_new_config =
          lspconfig[conf.lsp_client_name].document_config.default_config.on_new_config
        lspconfig[conf.lsp_client_name].setup(vim.tbl_extend("force", server_conf, {
          autostart = true,
          on_new_config = function(new_config, new_root_dir)
            -- Call the default handler if one is provided by lspconfig
            if default_on_new_config then
              default_on_new_config(new_config, new_root_dir)
            end
            -- Replace the command with the container command if locally cached
            local override_cmd = client_cfgs[conf.lsp_client_name].cmds[new_root_dir]
            new_config.cmd = override_cmd or default_cmd
          end,
        }))
        -- Set configured
        client_cfgs[conf.lsp_client_name].configured = true
      end

      -- Setup user commands
      for _, v in ipairs(conf.editor_cmds) do
        vim.api.nvim_create_user_command(v.name, function()
          lsp.dev_container_run_cmd(conf.container_name, conf.container_workdir, v.cmd, {
            uid = conf.container_uid,
            gid = conf.container_gid,
            on_exit = function()
              if v.restart_lsp then
                vim.schedule(function()
                  vim.cmd("LspRestart")
                  lib.notify("Restarted LSP", vim.log.levels.INFO)
                end)
              end
            end,
          })
        end, {
          desc = v.desc,
        })
      end
    end,
  })

  -- Set started
  user_cfgs[root_dir].started = true

  return true
end

--- Load config for the root directory into the local cache
---@param root_dir string the project root directory
---@return boolean
local function load_config(root_dir)
  if not user_cfgs[root_dir] or not user_cfgs[root_dir].conf then
    -- Read and validate conf file
    local conf = json.read(fs.join_paths(root_dir, DOCKER_DEV_FILE))
    if not validate_conf(conf) then
      return false
    end
    -- Replace placeholder text within conf file
    replace_placeholders(conf, root_dir)
    -- Add config file to local cache
    user_cfgs[root_dir] = { started = false, conf = conf }
  end

  local conf = user_cfgs[root_dir].conf
  if not client_cfgs[conf.lsp_client_name] then
    client_cfgs[conf.lsp_client_name] = { configured = false, cmds = {} }
  end
  if not client_cfgs[conf.lsp_client_name][root_dir] then
    -- Wrap command with docker execute
    local cmd = conf.lsp_client_cmd
    cmd = lsp.dev_container_get_cmd(
      conf.container_name,
      conf.container_workdir,
      cmd,
      { uid = conf.container_uid, gid = conf.container_gid }
    )
    -- Add client command to local cache
    client_cfgs[conf.lsp_client_name].cmds[root_dir] = cmd
  end

  return true
end

--- Run docker dev for the given file or the cwd
---@param filename string? the buffer filename being used or cwd by default
local function run(filename)
  local root_dir = fs.proj_dir(filename or vim.fn.getcwd(), { DOCKER_DEV_FILE })
  if root_dir then
    if load_config(root_dir) then
      setup_container(root_dir)
    end
  end
end

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

-- Try running for the cwd
run()

-- Create autocmd to start for other buffers
local augroup_startup =
  vim.api.nvim_create_augroup("user_plugin_docker_dev_startup", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = augroup_startup,
  desc = "Statup docker-dev when entering new buffer",
  callback = function(info)
    run(info.file)
  end,
})
