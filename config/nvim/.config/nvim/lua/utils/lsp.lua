local fs = require("utils.fs")
local map = vim.keymap.set

--- Insert into a table of values by a priority number
---@param tbl table(priority: number, value: any) destination
---@param new_tbl table(priority: number, value: any)
local function insert_by_priority(tbl, new_tbl)
  local inserted = false
  for i, v in ipairs(tbl) do
    if new_tbl.priority < v.priority then
      table.insert(tbl, i, new_tbl)
      inserted = true
      break
    end
  end
  if not inserted then
    table.insert(tbl, new_tbl)
  end
end

local M = {}

-- Store of additional attach handlers for the lsp 'on_attach' event
M.attach_handlers = {
  -- { priority = 0, value = nil },
}

-- Store of additional lsp capabilities
M.capabilities = {
  -- { priority = 0, value = nil },
}

--- Get the lsp clients on a specific buffer
---@param bufnr number? or current bufnr if not provided
---@return lsp.Client lsp client
function M.get_attached_clients(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if vim.bo.buftype ~= "" or filename == "" then
    return {}
  end
  return vim.lsp.get_active_clients({ bufnr = bufnr })
end

---@class lsp.ClientConfig: lsp_client_config_t
---@class lsp_client_config_t
---@field cmd? (string[]|fun(dispatchers: table):table)
---@field cmd_cwd? string
---@field cmd_env? (table)
---@field detached? boolean
---@field workspace_folders? (table)
---@field capabilities? table
---@field handlers? table<string,function>
---@field settings? table
---@field commands? table
---@field init_options? table
---@field name? string
---@field get_language_id? fun(bufnr: integer, filetype: string): string
---@field offset_encoding? string
---@field on_error? fun(code: integer)
---@field before_init? function
---@field on_init? function
---@field on_exit? fun(code: integer, signal: integer, client_id: integer)
---@field on_attach? fun(client: lsp.Client, bufnr: integer)
---@field trace? 'off'|'messages'|'verbose'|nil
---@field flags? table
---@field root_dir? string
---@field root_patterns? string[]

---Wrapper of `vim.lsp.start()`, starts and attaches LSP client for
---the current buffer
---@param config lsp_client_config_t|lsp.ClientConfig
---@param opts table?
---@param supports_docker_dev boolean?
---@return integer? client_id id of attached client or nil if failed
function M.start(config, opts, supports_docker_dev)
  if vim.bo.bt == "nofile" then
    return
  end
  supports_docker_dev = supports_docker_dev or true

  -- Setup config
  config = config or {}
  config.root_patterns = vim.tbl_extend("force", config.root_patterns or {}, { ".git/" })
  config.root_dir = fs.proj_dir(vim.api.nvim_buf_get_name(0), config.root_patterns)
  -- Try loading docker dev all requirements are met
  if
    supports_docker_dev
    and config.root_dir
    and _G.DockerDev
    and _G.DockerDev.start(config, opts)
  then
    return
  end
  -- Quit silently if command not installed
  if type(config.cmd) == "table" then
    if not config.cmd[1] or vim.fn.executable(config.cmd[1]) <= 0 then
      return 0
    end
    config.name = config.name or config.cmd[1]
  end
  return vim.lsp.start(config, opts)
end

---@class lsp_stop_opts_t
---@field retry integer?
---@field interval integer?
---@field on_close fun(client: lsp.Client)

---Stop LSP client with retries
---@param client_or_id integer|lsp.Client
---@param opts lsp_stop_opts_t?
function M.stop(client_or_id, opts)
  local client = type(client_or_id) == "number" and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as lsp.Client]]
  if not client then
    return
  end
  opts = opts or {}
  opts.retry = opts.retry or 4
  opts.interval = opts.interval or 500
  opts.on_close = opts.on_close or function() end

  if opts.retry <= 0 then
    vim.lsp.stop_client(client.id)
    opts.on_close(client)
    return
  end
  vim.lsp.stop_client(client.id)
  ---@diagnostic disable-next-line: invisible
  if client.is_stopped() then
    opts.on_close(client)
    return
  end
  vim.defer_fn(function()
    opts.retry = opts.retry - 1
    M.stop(client, opts)
  end, opts.interval)
end

---Restart and reattach LSP client
---@param client_or_id integer|lsp.Client
function M.restart(client_or_id)
  local client = type(client_or_id) == "number" and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as lsp.Client]]
  if not client then
    return
  end
  local config = client.config --[[@as lsp.ClientConfig]]
  local attached_buffers = client.attached_buffers
  M.stop(client, {
    on_close = function()
      for buf, _ in pairs(attached_buffers) do
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        vim.api.nvim_buf_call(buf, function()
          M.start(config)
        end)
      end
    end,
  })
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

--- Add an attach handler to the default on_attach function
---@param handler fun(client: lsp.Client, bufnr: integer)
---@param priority number?
function M.register_attach_handler(handler, priority)
  priority = priority or 5
  insert_by_priority(M.attach_handlers, { priority = priority, value = handler })
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = M.get_attached_clients(bufnr)
  -- Run the handler immediately if there is already a client attached
  for _, client in pairs(clients) do
    handler(client, bufnr)
  end
end

--- Add a capabilities to the default lsp capabilities
---@param capabilities table
---@param priority number?
function M.register_capabilities(capabilities, priority)
  priority = priority or 5
  insert_by_priority(M.capabilities, { priority = priority, value = capabilities })
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
      map(key.mode or "n", key[1], key[2], opts)
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

---Generate a new lsp config by using a base configuration and overriding it.
---Then append additional attach handlers and capabilities that were registered
---@param base lsp.ClientConfig?
---@param override lsp.ClientConfig?
---@return lsp.ClientConfig
function M.generate_config(base, override)
  local config = vim.tbl_deep_extend("force", base or {}, override or {})
  local on_attach = config.on_attach
  local capabilities = config.capabilities
  return vim.tbl_deep_extend("force", config, {
    on_attach = function(client, bufnr)
      -- Detach of larger files
      if vim.b["midfile"] then
        vim.defer_fn(function()
          vim.lsp.buf_detach_client(bufnr, client.id)
        end, 100)
        return
      end
      -- Call config attach handler
      if on_attach then
        on_attach(client, bufnr)
      end
      -- Call additional attach handlers
      for _, v in ipairs(M.attach_handlers) do
        if v.value and type(v.value) == "function" then
          v.value(client, bufnr)
        end
      end
    end,
    capabilities = (function()
      local ret = capabilities
      for _, v in pairs(M.capabilities) do
        if v.value and type(v.value) == "table" then
          ret = vim.tbl_extend("force", ret, v.value)
        end
      end
      return ret
    end)(),
  })
end

return M
