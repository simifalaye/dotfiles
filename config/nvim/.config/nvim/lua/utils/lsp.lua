local lib = require("utils.lib")
local map = require("utils.map")

local M = {}

--- Get the lsp clients on this buffer
function M.get_attached_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  return clients, bufnr
end

--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_active_clients.filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
function M.has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
end

--- Add an attach handler to be called with the on_attach lsp function
---@param handler fun(client: lsp.Client, bufnr: integer)
---@param once boolean? only run for one attached client
function M.register_attach_handler(handler, once)
  once = once and once or true
  if not vim.g.user_lsp_attach_handlers then
    vim.g.user_lsp_attach_handlers = {}
  end
  table.insert(vim.g.user_lsp_attach_handlers, handler)
  local clients, bufnr = M.get_attached_clients()
  for _, client in ipairs(clients) do
    -- Run the handler immediately if there is already a client attached
    handler(client, bufnr)
    if once then
      break
    end
  end
end

---@class UserLspKeys
---@field [1] string lhs
---@field [2] string|fun()|false rhs
---@field desc string?
---@field mode string|string[]|nil
---@field noremap boolean?
---@field remap boolean?
---@field expr boolean?
---@field id string?
---@field has string? map only if the client has a specific capability

--- Register lsp keys for the current buffer
---@param client lsp.Client
---@param bufnr integer
---@param keys UserLspKeys[]
function M.register_keys(client, bufnr, keys)
  for _, key in ipairs(keys) do
    if not key.has or client.server_capabilities[key.has .. "Provider"] then
      local opts = {}
      for k, v in pairs(key) do
        if type(k) ~= "number" and k ~= "mode" and k ~= "id" then
          opts[k] = v
        end
      end
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = bufnr
      map.map(key.mode or "n", key[1], key[2], opts)
    end
  end
end

--- Trigger the lsp on_rename handler when renaming a file
---@param from string old name
---@param to string new name
function M.on_rename(from, to)
  local clients = M.get_attached_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

--- Start a dev containter for lsp
---@param src string the path to your local project
---@param tar string the path on the container to mount your project
---@param name string the name of the container to use
---@param image string the image to use
---@param opts table? the func options
---@return boolean
function M.dev_container_setup(src, tar, name, image, opts)
  opts = lib.extend_tbl({
    uid = 0,
    gid = 0,
    cmd = "echo 'done'",
  }, opts and opts or {})
  -- Check if the container already exists and is running
  local containerStatus =
    vim.fn.systemlist("docker ps --format '{{.Names}}' --filter name=" .. name)
  if #containerStatus == 0 then
    -- Container doesn't exist, start it
    local keep_alive_cmd = "tail -f /dev/null"
    local command = string.format(
      "docker run --user %s --rm -d --mount type=bind,source=%s,target=%s --name %s %s sh -c '%s && %s'",
      string.format("%s:%s", opts.uid, opts.gid),
      src,
      tar,
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
function M.dev_container_wait(name, cmd, opts)
  opts = lib.extend_tbl({
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
          lib.notify(string.format("Dev container ready: %s", name), vim.log.levels.INFO)
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
---@param cmd table the lsp command on the container
---@param opts table? the function options
---@return table
function M.dev_container_get_cmd(name, workdir, cmd, opts)
  opts = lib.extend_tbl({
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
    table.concat(cmd, " "),
  }
end

--- Run a command in the dev container
---@param name string the container name
---@param workdir string the container workind dir
---@param cmd string the command to run
---@param opts table? the function options
function M.dev_container_run_cmd(name, workdir, cmd, opts)
  opts = lib.extend_tbl({
    uid = 0,
    gid = 0,
  }, opts and opts or {})
  vim.cmd("new")
  vim.fn.termopen(
    string.format(
      "docker exec --user %s -i -w %s %s sh -c '%s'",
      string.format("%s:%s", opts.uid, opts.gid),
      workdir,
      name,
      cmd
    )
  )
end

return M
