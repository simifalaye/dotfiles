local utils = require("utils")
local ui = require("utils.ui")
local augroup = require("utils.command").augroup

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

--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_active_clients.filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
M.has_capability = function(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
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

M.on_attach = function(client, bufnr)
  local m = require("utils.map")
  local o = { buffer = bufnr }

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Default LSP mappings
  m.nnoremap("[d", vim.diagnostic.goto_prev, "LSP: Goto prev diag", o)
  m.nnoremap("]d", vim.diagnostic.goto_next, "LSP: Goto next diag", o)
  m.nnoremap("<localleader>d", vim.diagnostic.open_float, "LSP: Diagnostics line", o)
  m.nnoremap("<localleader>D", vim.diagnostic.setloclist, "LSP: Diagnostics list", o)
  m.nnoremap("gD", vim.lsp.buf.declaration, "LSP: Goto decl", o)
  m.nnoremap("gd", vim.lsp.buf.definition, "LSP: Goto def", o)
  m.nnoremap("gs", vim.lsp.buf.signature_help, "LSP: Show signature", o)
  m.nnoremap("gi", vim.lsp.buf.implementation, "LSP: Goto impl", o)
  m.nnoremap("gr", vim.lsp.buf.references, "LSP: Goto ref", o)
  m.nnoremap("K", vim.lsp.buf.hover, "LSP: Hover", o)
  m.nnoremap("<localleader>r", vim.lsp.buf.rename, "LSP: Rename", o)
  m.group("<localleader>w", "+workspace")
  m.nnoremap(
    "<localleader>wa",
    vim.lsp.buf.add_workspace_folder,
    "LSP: Add workspace folder",
    o
  )
  m.nnoremap(
    "<localleader>wr",
    vim.lsp.buf.remove_workspace_folder,
    "LSP: Remove workspace folder",
    o
  )
  m.nnoremap("<localleader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "LSP: List workspace folders", o)

  -- Conditionals
  if client.supports_method("textDocument/typeDefinition") then
    m.nnoremap("gy", vim.lsp.buf.type_definition, "Goto type", o)
  end
  if client.supports_method("textDocument/codeAction") then
    m.noremap(
      { "n", "x" },
      "<localleader>a",
      vim.lsp.buf.code_action,
      "LSP: Code action",
      o
    )
  end
  if client.supports_method("textDocument/formatting") then
    m.nnoremap("<localleader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: Format", o)
  end
  if client.supports_method("textDocument/codeLens") then
    augroup("user_lsp_codelens_refresh", {
      {
        desc = "Refresh codelens",
        event = { "InsertLeave", "BufEnter" },
        buffer = bufnr,
        command = function()
          if not M.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
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
    m.nnoremap("<localleader>l", function()
      vim.lsp.codelens.refresh()
    end, "LSP: Codelens refresh")
    m.nnoremap("<localleader>L", function()
      vim.lsp.codelens.run()
    end, "LSP: Codelens run")
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
          if
            not M.has_capability("textDocument/documentHighlight", { bufnr = bufnr })
          then
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
end

return M
