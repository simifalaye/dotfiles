-- Only load if not already loaded
if vim.g.loaded_user_plugin_docker_dev then
  return
end
vim.g.loaded_user_plugin_docker_dev = true

local fs = require("utils.fs")
local json = require("utils.json")
local lib = require("utils.lib")
local lsp = require("utils.lsp")

-- Constants
DOCKER_DEV_FILE = ".docker-dev.json"
PLACEHOLDERS = {
  root_dir = "{{root_dir}}",
}

-- Example configuration (.docker-dev.json)
-- {
--   "image_name": "my_cpp_app_image",
--   "container_name": "my_cpp_app",
--   "container_workdir": "/src",
--   "container_setup_cmd": "sudo apt update && sudo apt install -y clangd && wget -O /tmp/bcc.deb https://github.com/kiron1/bazel-compile-commands/releases/download/v0.8.2/bazel-compile-commands_0.8.2_amd64.deb && sudo dpkg -i /tmp/bcc.deb",
--   "container_ready_cmd": "which clangd",
--   "container_uid": 0,
--   "container_gid": 0,
--   "mounts": [
--     "{{project_root}}:/src"
--   ],
--   "client_name": "clangd",
--   "cmd": [
--     "/usr/bin/clangd",
--     "--log=verbose"
--     "--background-index",
--     "--header-insertion=iwyu",
--     "--offset-encoding=utf-16",
--     "--path-mappings",
--     "{{project_root}}=/src"
--   ],
--   "cmd_append": false,
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
    { name = "image_name", type = "string" },
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
    { name = "mounts", type = "table", default = {} },
    { name = "client_name", type = "string" },
    { name = "cmd", type = "table" },
    { name = "cmd_append", type = "boolean", false },
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
  -- Validate individual cmd elements
  for _, v in ipairs(conf.cmd) do
    if type(v) ~= "string" then
      vim.schedule(function()
        lib.notify("All cmd elements must be a string", vim.log.levels.ERROR)
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
      or not v.workdir
      or type(v.workdir) ~= "string"
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
    return v:gsub(PLACEHOLDERS.root_dir, root_dir)
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

--------------------------------------------------------------------------------
--  Lib
--------------------------------------------------------------------------------

local DockerDev = {}
_G.DockerDev = DockerDev

DockerDev.config_cache = {}

--- Start a dev containter for lsp
---@param name string the name of the container to use
---@param image string the image to use
---@param opts table? the func options
---@return boolean
function DockerDev.container_start(name, image, opts)
  opts = vim.tbl_deep_extend("force", {
    uid = 0,
    gid = 0,
    cmd = "echo 'done'",
    mounts = {},
  }, opts and opts or {})
  -- Check if the container already exists and is running
  local containerStatus =
    vim.fn.systemlist("docker ps --format '{{.Names}}' --filter name=" .. name)
  if #containerStatus == 0 then
    -- Container doesn't exist, start it
    local keep_alive_cmd = "tail -f /dev/null"
    local mount_str = ""
    for _, v in ipairs(opts.mounts) do
      if v.type and v.source and v.target then
        mount_str = mount_str
          .. string.format(
            "--mount type=%s,source=%s,target=%s ",
            v.type,
            v.source,
            v.target
          )
      end
    end

    local command = string.format(
      "docker run --user %s --rm -d %s --name %s %s sh -c '%s && %s'",
      string.format("%s:%s", opts.uid, opts.gid),
      mount_str,
      name,
      image,
      opts.cmd,
      keep_alive_cmd
    )
    local _ = vim.fn.system(command)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
      lib.notify("Dev container started: " .. name, vim.log.levels.INFO)
      return true
    else
      lib.notify("Dev container failed to start: " .. exit_code, vim.log.levels.ERROR)
      return false
    end
  else
    lib.notify("Dev container already running", vim.log.levels.DEBUG)
    return true
  end
end

--- Wait for a dev container to be ready
---@param name string the container name
---@param cmd string the command to check if it's ready
---@param opts table? the function options
function DockerDev.container_wait(name, cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    uid = 0,
    gid = 0,
    cb = function() end,
    max_attempts = 60,
    interval = 1000,
  }, opts and opts or {})
  local attempts = 0
  local function run()
    attempts = attempts + 1
    -- Run the command inside the Docker container
    local command = string.format(
      "docker exec --user %s %s sh -c '%s'",
      string.format("%s:%s", opts.uid, opts.gid),
      name,
      cmd
    )
    local _ = vim.fn.jobstart(command, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          lib.notify(string.format("Dev container ready: %s", name), vim.log.levels.DEBUG)
          opts.cb()
        else
          lib.notify(
            string.format("Dev container not ready: %s, exit_code: %d", name, exit_code),
            vim.log.levels.DEBUG
          )
          -- Retry the command if the maximum number of attempts is not reached
          if attempts < opts.max_attempts or opts.max_attempts == 0 then
            vim.fn.timer_start(opts.interval, run)
          else
            lib.notify(
              string.format(
                "Dev container never became ready: %s, attempts: %d",
                name,
                attempts
              ),
              vim.log.levels.ERROR
            )
          end
        end
      end,
    })
  end
  -- Start the initial command execution
  run()
end

--- Generate a docker command for the lsp server
---@param name string the container name
---@param workdir string the working directory of the container
---@param cmd table|string the lsp command on the container
---@param opts table? the function options
---@return table
function DockerDev.generate_container_cmd(name, workdir, cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    uid = 0,
    gid = 0,
  }, opts and opts or {})
  return {
    "docker",
    "exec",
    "--user",
    string.format("%s:%s", opts.uid, opts.gid),
    "-i",
    "-w",
    workdir,
    name,
    "/bin/sh",
    "-c",
    type(cmd) == "table" and table.concat(cmd, " ") or cmd,
  }
end

--- Run a command in the dev container
---@param name string the container name
---@param workdir string the container workind dir
---@param cmd string the command to run
---@param opts table? the function options
function DockerDev.container_run_cmd(name, workdir, cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    uid = 0,
    gid = 0,
    on_exit = nil,
  }, opts and opts or {})
  vim.cmd("new")
  vim.fn.termopen(
    string.format(
      "docker exec --user %s -i -w %s %s sh -c '%s'",
      string.format("%s:%s", opts.uid, opts.gid),
      workdir,
      name,
      cmd
    ),
    { on_exit = opts.on_exit }
  )
end

--- Setup a dev container, starting it if it's not already running and waiting
---for it to be ready before starting the lsp within the container
---@param dconfig table the docker dev config
---@param config table
---@param opts table? vim.lsp.start opts
---@return boolean true if successful
function DockerDev.container_setup(dconfig, config, opts)
  -- Construct build mounts option
  local mounts = {}
  for _, v in ipairs(dconfig.mounts) do
    local src, tar = v:match("([^:]+):([^:]+)")
    table.insert(mounts, { type = "bind", source = src, target = tar })
  end

  -- Start container
  if
    not DockerDev.container_start(dconfig.container_name, dconfig.image_name, {
      uid = dconfig.container_uid,
      gid = dconfig.container_gid,
      cmd = dconfig.container_setup_cmd,
      mounts = mounts,
    })
  then
    return false
  end

  -- Wait till the dev container is ready and start the lsp client
  DockerDev.container_wait(dconfig.container_name, dconfig.container_ready_cmd, {
    uid = dconfig.container_uid,
    gid = dconfig.container_gid,
    cb = function()
      -- Modify config
      local c = config
      c.cmd = DockerDev.generate_container_cmd(
        dconfig.container_name,
        dconfig.container_workdir,
        dconfig.cmd_append and { unpack(c.cmd), unpack(dconfig.cmd) } or dconfig.cmd,
        { uid = dconfig.container_uid, gid = dconfig.container_gid }
      )
      -- Start client
      local client_id = vim.lsp.start(c, opts)
      if not client_id then
        lib.notify("Failed to start docker dev client", vim.log.levels.ERROR)
      end
      -- Setup user commands
      for _, v in ipairs(dconfig.editor_cmds) do
        vim.api.nvim_create_user_command(v.name, function()
          DockerDev.container_run_cmd(dconfig.container_name, v.workdir, v.cmd, {
            uid = dconfig.container_uid,
            gid = dconfig.container_gid,
            on_exit = function()
              if v.restart_lsp and client_id then
                vim.schedule(function()
                  lsp.restart(client_id)
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

  return true
end

function DockerDev.start(config, opts)
  if vim.fn.executable("docker") <= 0 then
    return false
  end

  local dconfig = _G.DockerDev.config_cache[config.root_dir]
  if dconfig == nil then
    local conf_path = fs.join_paths(config.root_dir, DOCKER_DEV_FILE)
    local stat = vim.loop.fs_stat(conf_path)
    if not stat then
      lib.notify("No docker dev config at: " .. conf_path, vim.log.levels.DEBUG)
      return false
    end
    -- Read and validate conf file
    dconfig = json.read(conf_path)
    if not validate_conf(dconfig) then
      return false
    end
    -- Replace placeholder text within conf file
    replace_placeholders(dconfig, config.root_dir)
    -- Cache config
    _G.DockerDev.config_cache[config.root_dir] = dconfig
  end
  -- Check if this is the correct client we're after
  if config.name ~= dconfig.client_name then
    return false
  end
  -- Setup container
  return DockerDev.container_setup(dconfig, config, opts)
end
