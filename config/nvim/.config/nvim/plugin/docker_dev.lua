-- Only load if not already loaded
if vim.g.loaded_user_plugin_docker_dev or vim.fn.executable("docker") <= 0 then
  return
end
vim.g.loaded_user_plugin_docker_dev = true

local lib = require("utils.lib")

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
  local default_uid = tonumber(vim.fn.expand("$UID"))
  local default_gid = tonumber(vim.fn.expand("$GID"))
  for _, v in ipairs({
    { name = "image_name",          type = "string" },
    { name = "container_name",      type = "string" },
    { name = "container_workdir",   type = "string", default = "/app" },
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
    { name = "mounts",      type = "table", default = {} },
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
---for it to be ready
---@param config table the docker dev config
---@return boolean true if successful
function DockerDev.container_setup(config)
  -- Construct build mounts option
  local mounts = {}
  for _, v in ipairs(config.mounts) do
    local src, tar = v:match("([^:]+):([^:]+)")
    table.insert(mounts, { type = "bind", source = src, target = tar })
  end

  -- Start container
  if
      not DockerDev.container_start(config.container_name, config.image_name, {
        uid = config.container_uid,
        gid = config.container_gid,
        cmd = config.container_setup_cmd,
        mounts = mounts,
      })
  then
    return false
  end

  -- Wait till the dev container is ready and setup custom commands
  DockerDev.container_wait(config.container_name, config.container_ready_cmd, {
    uid = config.container_uid,
    gid = config.container_gid,
    cb = function()
      -- Setup custom commands
      for _, v in ipairs(config.editor_cmds) do
        vim.api.nvim_create_user_command(v.name, function()
          DockerDev.container_run_cmd(config.container_name, v.workdir, v.cmd, {
            uid = config.container_uid,
            gid = config.container_gid,
            on_exit = function()
              lib.notify(v.name .. " completed", vim.log.levels.INFO)
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

---
--  Main
---

local user_docker_dev_grp_id = vim.api.nvim_create_augroup("UserDockerDev", {})
vim.api.nvim_create_autocmd("BufRead", {
  desc = "Load docker dev configuration if one exists in the project root",
  group = user_docker_dev_grp_id,
  callback = function(args)
    local fs = require("utils.fs")
    local root_dir = fs.proj_dir(vim.api.nvim_buf_get_name(args.buf), { DOCKER_DEV_FILE })
    if not root_dir then
      return
    end

    local config = _G.DockerDev.config_cache[root_dir]
    if not config then
      local conf_path = fs.join_paths(root_dir, DOCKER_DEV_FILE)
      if not fs.file_exists(conf_path) then
        return
      end
      -- Read and validate conf file
      config = require("utils.json").read(conf_path)
      if not validate_conf(config) then
        return
      end
      -- Replace placeholder text within conf file
      replace_placeholders(config, root_dir)
      -- Cache config
      _G.DockerDev.config_cache[root_dir] = config
    end

    DockerDev.container_setup(config)
  end,
})
