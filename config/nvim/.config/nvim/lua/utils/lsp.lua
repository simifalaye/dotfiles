local utils = require("utils")
local prequire = require("utils.prequire")
local augroup = require("utils.command").augroup

--- Get the lsp clients on this buffer
local function get_attached_clients()
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
local has_capability = function(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
end

local formatting_opts = {
  async = true,
  filter = nil,
}

local attach_handlers = {}

local M = {}

--- Default capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.documentationFormat =
  { "markdown", "plaintext" }
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
M.capabilities.textDocument.completion.completionItem.resolveSupport =
  { properties = { "documentation", "detail", "additionalTextEdits" } }
M.capabilities.textDocument.foldingRange =
  { dynamicRegistration = false, lineFoldingOnly = true }

-- Default flags
M.flags = {
  debounce_text_changes = 150,
}

-- Default signs
M.signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

-- Default diagnostics (based on mode toggle in ./ui.lua)
local default_diagnostics = {
  virtual_text = true,
  signs = { active = M.signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
M.diagnostics = {
  -- diagnostics off
  [0] = utils.extend_tbl(default_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }),
  -- status only
  utils.extend_tbl(default_diagnostics, { virtual_text = false, signs = false }),
  -- virtual text off, signs on
  utils.extend_tbl(default_diagnostics, { virtual_text = false }),
  -- all diagnostics on
  default_diagnostics,
}

--- Set the formatting filter function to use
---@param func fun(c: lsp.Client): boolean
M.set_format_filter = function(func)
  formatting_opts.filter = func
end

--- Add an attach handler to be called with the on_attach lsp function
---@param handler fun(args: lsp.Client, bufnr: integer)
---@param once boolean?
M.register_attach_handler = function(handler, once)
  once = once and once or true
  table.insert(attach_handlers, handler)
  local clients, bufnr = get_attached_clients()
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
---@field [2]? string|fun()|false rhs
---@field desc? string
---@field mode? string|string[]
---@field noremap? boolean
---@field remap? boolean
---@field expr? boolean
---@field id string
---@field has string

--- Register lsp keys for the current buffer
---@param client lsp.Client
---@param bufnr integer
---@param keys UserLspKeys[]
M.register_keys = function(client, bufnr, keys)
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
      require("utils.map").map(key.mode or "n", key[1], key[2], opts)
    end
  end
end

--- Configures lsp diagnostics
M.setup_diagnostics = function()
  -- Register signs
  for _, sign in ipairs(M.signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  -- Set diagnotics based on mode
  vim.diagnostic.config(M.diagnostics[vim.g.user_diagnostics_mode])
end

--- Get a list of common lsp capabilities
---@return table
M.get_capabilities = function()
  local capabilities = M.capabilities
  local cmp_lsp = prequire("cmp_nvim_lsp")
  if cmp_lsp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

--- Common lsp attach handler
---@param client lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  local m = require("utils.map")

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local keys = {
    { "]d", vim.diagnostic.goto_next, desc = "Diagnostic (lsp)" },
    { "[d", vim.diagnostic.goto_prev, desc = "Diagnostic (lsp)" },
    {
      "<leader>ca",
      vim.lsp.buf.code_action,
      desc = "Code Action (lsp)",
      mode = { "n", "v" },
      has = "codeAction",
    },
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics (lsp)" },
    { "<leader>cD", vim.diagnostic.setloclist, desc = "Doc Diagnostics (lsp)" },
    {
      "<leader>cf",
      function()
        vim.lsp.buf.format(formatting_opts)
      end,
      desc = "Format Document (lsp)",
      has = "documentFormatting",
    },
    {
      "<leader>cf",
      function()
        vim.lsp.buf.format(formatting_opts)
      end,
      desc = "Format Range (lsp)",
      mode = "v",
      has = "documentRangeFormatting",
    },
    { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Info (lsp)" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename (lsp)", has = "rename" },
    { "gd", vim.lsp.buf.definition, desc = "Goto Def (lsp)", has = "definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Dec (lsp)", has = "declaration" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature (lsp)", has = "signatureHelp" },
    {
      "gi",
      vim.lsp.buf.implementation,
      desc = "Goto Impl (lsp)",
      has = "implementation",
    },
    { "gr", vim.lsp.buf.references, desc = "Goto Ref (lsp)", has = "references" },
    {
      "gz",
      vim.lsp.buf.type_definition,
      desc = "Goto Type (lsp)",
      has = "typeDefinition",
    },
    { "K", vim.lsp.buf.hover, desc = "Hover (lsp)", has = "hover" },
  }

  if client.supports_method("textDocument/codeLens") then
    augroup("user_lsp_codelens_refresh", {
      {
        desc = "Refresh codelens",
        event = { "InsertLeave", "BufEnter" },
        buffer = bufnr,
        command = function()
          if not has_capability("textDocument/codeLens", { bufnr = bufnr }) then
            vim.api.nvim_del_augroup_by_name("user_lsp_codelens_refresh")
            return
          end
          if vim.g.user_codelens_enabled then
            vim.lsp.codelens.refresh()
          end
        end,
      },
    })
    if vim.g.user_codelens_enabled then
      vim.lsp.codelens.refresh()
    end
    table.insert(keys, {
      "<leader>cl",
      function()
        vim.lsp.codelens.refresh()
      end,
      desc = "Codelens refresh (lsp)",
    })
    table.insert(keys, {
      "<leader>cL",
      function()
        vim.lsp.codelens.run()
      end,
      desc = "Codelens run (lsp)",
    })
  end
  if
    (
      client.supports_method("textDocument/semanticTokens/full")
      or client.supports_method("textDocument/semanticTokens/full/delta")
    ) and vim.lsp.semantic_tokens
  then
    if vim.b.user_semantic_tokens_enabled == nil then
      vim.b.user_semantic_tokens_enabled = vim.g.user_semantic_tokens_enabled
    end
    vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
      bufnr,
      client.id
    )
    m.nnoremap("<leader>uy", function()
      require("utils.ui").toggle_buffer_semantic_tokens(bufnr)
    end, "Toggle LSP semantic highlight")
  end
  if client.supports_method("textDocument/documentHighlight") then
    augroup("user_lsp_document_highlight", {
      {
        desc = "highlight references when cursor holds",
        event = { "CursorHold", "CursorHoldI" },
        buffer = bufnr,
        command = function()
          if not has_capability("textDocument/documentHighlight", { bufnr = bufnr }) then
            vim.api.nvim_del_augroup_by_name("user_lsp_document_highlight")
            return
          end
          vim.lsp.buf.document_highlight()
        end,
      },
      {
        desc = "Clear references when cursor moves",
        event = { "CursorMoved", "CursorMovedI" },
        buffer = bufnr,
        command = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end

  -- Register lsp keys
  M.register_keys(client, bufnr, keys)

  -- Call additional attach handlers
  for _, handler in ipairs(attach_handlers) do
    handler(client, bufnr)
  end
end

return M
