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

-- Constants
DOCKER_DEV_FILE = ".docker-dev.json"
PWD_TEXT_REPL = "{{pwd}}"

-- Example configuration (.docker-dev.json)
-- {
--   "container_name": "my_cpp_app",
--   "container_workdir": "/src",
--   "container_setup_cmd": "sudo apt update && sudo apt install -y clangd && wget -O /tmp/bcc.deb https://github.com/kiron1/bazel-compile-commands/releases/download/v0.8.2/bazel-compile-commands_0.8.2_amd64.deb && sudo dpkg -i /tmp/bcc.deb",
--   "container_ready_cmd": "which clangd",
--   "image_name": "my_cpp_app_image",
--   "lsp_name": "clangd",
--   "lsp_server_cmd": "/usr/bin/clangd --log=verbose --background-index --header-insertion=iwyu --offset-encoding=utf-16 --path-mappings {{pwd}}=/src",
--   "mounts": [
--     "{{pwd}}:/src"
--   ],
--   "editor_cmds": [
--     {
--       "name": "CCGenerate",
--       "desc": "Generate/refresh compile_commands file",
--       "cmd": "bazel-compile-commands -v -s '--output_user_root=/working/bazel' -b '--compilation_mode=opt' -b '--config=prod' //src/... //test/ut/..."
--     }
--   ]
-- }

--- Validate a docker dev config
---@param conf table
---@return boolean true if successfully validated
local function validate_conf(conf)
  for _, v in ipairs({
    { name = "container_name", type = "string" },
    { name = "container_workdir", type = "string", default = "/app" },
    { name = "container_setup_cmd", type = "string", default = "echo 'Done'" },
    { name = "container_ready_cmd", type = "string", default = "return 0" },
    { name = "image_name", type = "string" },
    { name = "lsp_name", type = "string" },
    { name = "lsp_server_cmd", type = "string", default = "" },
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
  for _, v in ipairs(conf.editor_cmds) do
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
  end
  return true
end

local function replace_text(conf)
  local function repl(v)
    return v:gsub(PWD_TEXT_REPL, vim.fn.getcwd())
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

--- Setup and run the lsp server within the docker container
---@param conf table
local function setup(conf)
  local uid = vim.fn.expand("$UID")
  local gid = vim.fn.expand("$GID")

  -- Disable lsp autostart since we will be starting the client manually
  lsp.autostart = false

  -- Build mounts options
  local mounts = {}
  for _, v in ipairs(conf.mounts) do
    local src, tar = v:match("([^:]+):([^:]+)")
    table.insert(mounts, { type = "bind", source = src, target = tar })
  end

  -- Start container if not started
  if
    not lsp.dev_container_setup(
      conf.container_name,
      conf.image_name,
      { uid = uid, gid = gid, cmd = conf.container_setup_cmd, mounts = mounts }
    )
  then
    return
  end

  -- Wait till the dev container is ready and then start the lsp client
  lsp.dev_container_wait(conf.container_name, conf.container_ready_cmd, {
    uid = uid,
    gid = gid,
    cb = function()
      local lspconfig = prequire("lspconfig")
      if not lspconfig then
        return
      end

      local server_conf = require("static.lsp-servers")[conf.lsp_name]

      -- Wrap command with docker execute
      server_conf.cmd = conf.lsp_server_cmd and conf.lsp_server_cmd or server_conf.cmd
      server_conf.cmd = lsp.dev_container_get_cmd(
        conf.container_name,
        conf.container_workdir,
        server_conf.cmd,
        { uid = uid, gid = gid }
      )

      -- Register any additional keymaps
      local keys = server_conf.keys
      server_conf.keys = nil
      if keys then
        lsp.register_attach_handler(function(client, bufnr)
          if client.name == conf.lsp_name then
            lsp.register_keys(client, bufnr, keys)
          end
        end)
      end

      -- Setup config with lspconfig
      lspconfig[conf.lsp_name].setup(server_conf)

      -- Start the lsp client manually
      vim.cmd("LspStart")

      -- Setup user commands
      for _, v in ipairs(conf.editor_cmds) do
        vim.api.nvim_create_user_command(v.name, function()
          lsp.dev_container_run_cmd(
            conf.container_name,
            conf.container_workdir,
            v.cmd,
            { uid = uid, gid = gid }
          )
        end, {
          desc = v.desc,
        })
      end
    end,
  })
end

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

-- Only load docker desktop if the is a config file within the project
local root_dir = fs.proj_dir(vim.fn.expand("%:p"), { DOCKER_DEV_FILE })
if not root_dir then
  return
end

-- Read and validate conf file
local conf_file = fs.join_paths(root_dir, DOCKER_DEV_FILE)
local conf = json.read(conf_file)
if not validate_conf(conf) then
  return
end

-- Replace text within conf file
replace_text(conf)

-- Setup config
setup(conf)
