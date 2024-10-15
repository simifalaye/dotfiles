-- Ex. local config (.nlsp.json):
-- {
--   "clangd": {
--     "disable": false, // Default: false
--     "cmd": ["clangd"]
--     ...  // Any other server config
--   }
-- }
_G.local_lsp_conf = _G.local_lsp_conf or {}

--- Get cached local lsp configuration or read from config file
---@param root_dir string
---@return table
local function load_local_config(root_dir)
  local conf = _G.local_lsp_conf[root_dir]
  if conf then
    return conf
  end

  local conf_path = vim.fs.joinpath(root_dir, ".nlsp.json")
  if not require("utils.fs").file_exists(conf_path) then
    return {}
  end
  conf = require("utils.json").read(conf_path)
  _G.local_lsp_conf[root_dir] = conf
  return {}
end

local M = {}

---@type lsp_client_config_t
---@diagnostic disable-next-line: missing-fields
M.default_config = {
  root_patterns = require("utils.fs").root_patterns,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
}

---@class vim.lsp.ClientConfig: lsp_client_config_t
---@class lsp_client_config_t
---@field cmd? (string[]|fun(dispatchers: table):table)
---@field cmd_cwd? string
---@field cmd_env? (table)
---@field detached? boolean
---@field workspace_folders? (table)
---@field capabilities? lsp.ClientCapabilities
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
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field trace? 'off'|'messages'|'verbose'|nil
---@field flags? table
---@field root_dir? string
---@field root_patterns? string[]

---Wrapper of `vim.lsp.start()`, starts and attaches LSP client for
---the current buffer
---@param config lsp_client_config_t
---@param opts table?
---@return integer? client_id id of attached client or nil if failed
function M.start(config, opts)
  if vim.b.bigfile or vim.bo.bt == "nofile" then
    return
  end
  -- Quit silently if command not installed
  local cmd_type = type(config.cmd)
  local cmd_exec = cmd_type == "table" and config.cmd[1]
  if cmd_type == "table" and vim.fn.executable(cmd_exec or "") == 0 then
    return
  end
  local client_name = config.name or cmd_exec
  -- Get root dir
  local buf_name = vim.api.nvim_buf_get_name(0)
  local root_dir = vim.fn.fnamemodify(
    vim.fs.root(
      buf_name,
      vim.list_extend(config.root_patterns or {}, M.default_config.root_patterns or {})
    ) or vim.fs.dirname(buf_name),
    "%:p"
  )
  if not vim.uv.fs_stat(root_dir) then
    return
  end
  -- Get local config
  local local_conf = load_local_config(root_dir)[client_name]
  if local_conf then
    if local_conf.disable ~= nil and local_conf.disable == true then
      return
    end
    local_conf.disable = nil
    config = vim.tbl_deep_extend("force", config or {}, local_conf)
  end
  -- Start client
  return vim.lsp.start(
    vim.tbl_deep_extend("keep", config or {}, {
      name = client_name,
      root_dir = root_dir,
    }, M.default_config) --[[@as vim.lsp.ClientConfig]],
    opts
  )
end

---@class lsp_stop_opts_t
---@field retry integer?
---@field interval integer?
---@field on_close fun(client: vim.lsp.Client)

---Stop LSP client with retries
---@param client_or_id integer|vim.lsp.Client
---@param opts lsp_stop_opts_t?
function M.stop(client_or_id, opts)
  local client = type(client_or_id) == "number" and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as vim.lsp.Client]]
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
---@param client_or_id integer|vim.lsp.Client
function M.restart(client_or_id)
  local client = type(client_or_id) == "number" and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as vim.lsp.Client]]
  if not client then
    return
  end
  local config = client.config --[[@as vim.lsp.ClientConfig]]
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
---@param filter vim.lsp.get_clients.Filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
function M.has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
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
---@param client vim.lsp.Client
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
      vim.keymap.set(key.mode or "n", key[1], key[2], opts)
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

return M
