--- Common lsp attach handler
---@param client lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  local lsp = require("utils.lsp")
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Setup main keymaps
  vim.keymap.set(
    "n",
    "<localleader>w",
    "<localleader>w",
    { buffer = true, desc = "+workspace" }
  )
  local keys = {
    { "]d", vim.diagnostic.goto_next, desc = "Diagnostic (lsp)" },
    { "[d", vim.diagnostic.goto_prev, desc = "Diagnostic (lsp)" },
    {
      "<localleader>a",
      vim.lsp.buf.code_action,
      desc = "Code Action (lsp)",
      mode = { "n", "v" },
      has = "codeAction",
    },
    { "<localleader>d", vim.diagnostic.open_float, desc = "Line Diagnostics (lsp)" },
    { "<localleader>D", vim.diagnostic.setloclist, desc = "Doc Diagnostics (lsp)" },
    {
      "<localleader>f",
      function()
        vim.lsp.buf.format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format Doc (lsp)",
    },
    { "<localleader>r", vim.lsp.buf.rename, desc = "Rename (lsp)", has = "rename" },
    {
      "<localleader>l",
      function()
        vim.lsp.codelens.refresh()
      end,
      desc = "Codelens refresh (lsp)",
      has = "codeLens",
    },
    {
      "<localleader>L",
      function()
        vim.lsp.codelens.run()
      end,
      desc = "Codelens run (lsp)",
      has = "codeLens",
    },
    {
      "<localleader>wa",
      vim.lsp.buf.add_workspace_folder,
      desc = "Add Folder (lsp)",
    },
    {
      "<localleader>wr",
      vim.lsp.buf.remove_workspace_folder,
      desc = "Remove Folder (lsp)",
    },
    {
      "<localleader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = "List Folders (lsp)",
    },
    { "gd", vim.lsp.buf.definition, desc = "Goto Def (lsp)", has = "definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Dec (lsp)", has = "declaration" },
    {
      "gK",
      vim.lsp.buf.signature_help,
      desc = "Signature (lsp)",
      has = "signatureHelp",
    },
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

  -- Register lsp keys
  lsp.register_keys(client, bufnr, keys)

  -- Setup autocmds
  if client.supports_method("textDocument/codeLens") and vim.g.user_codelens_enabled then
    vim.lsp.codelens.refresh()
    local codelens_groupid =
      vim.api.nvim_create_augroup("user_lsp_codelens_refresh", {})
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
      desc = "Refresh codelens",
      group = codelens_groupid,
      buffer = bufnr,
      callback = function()
        if not lsp.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
          vim.api.nvim_del_augroup_by_name("user_lsp_codelens_refresh")
          return
        end
        if vim.g.user_codelens_enabled then
          vim.lsp.codelens.refresh()
        end
      end,
    })
  end
  if
    (
      client.supports_method("textDocument/semanticTokens/full")
      or client.supports_method("textDocument/semanticTokens/full/delta")
    ) and vim.lsp.semantic_tokens
  then
    if vim.b["user_semantic_tokens_enabled"] == nil then
      vim.b["user_semantic_tokens_enabled"] = vim.g.user_semantic_tokens_enabled
    end
    vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
      bufnr,
      client.id
    )
  end
  if client.supports_method("textDocument/documentHighlight") then
    local highlight_groupid =
      vim.api.nvim_create_augroup("user_lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      desc = "highlight references when cursor holds",
      group = highlight_groupid,
      buffer = bufnr,
      callback = function()
        if
          not lsp.has_capability("textDocument/documentHighlight", { bufnr = bufnr })
        then
          vim.api.nvim_del_augroup_by_name("user_lsp_document_highlight")
          return
        end
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      desc = "Clear references when cursor moves",
      group = highlight_groupid,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local flags = {
  debounce_text_changes = 150,
}

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = flags,
}
