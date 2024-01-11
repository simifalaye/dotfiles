local utils = require("utils")

--- Common lsp attach handler
---@param client lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  local map = utils.map
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Setup main keymaps
  map.group("<localleader>w", "+workspace", "n", true)
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
  utils.lsp.register_keys(client, bufnr, keys)

  -- Setup autocmds
  if client.supports_method("textDocument/codeLens") and vim.g.user_codelens_enabled then
    vim.lsp.codelens.refresh()
    utils.augroup("user_lsp_codelens_refresh", {
      {
        desc = "Refresh codelens",
        event = { "InsertLeave", "BufEnter" },
        buffer = bufnr,
        command = function()
          if not utils.lsp.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
            vim.api.nvim_del_augroup_by_name("user_lsp_codelens_refresh")
            return
          end
          if vim.g.user_codelens_enabled then
            vim.lsp.codelens.refresh()
          end
        end,
      },
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
  end
  if client.supports_method("textDocument/documentHighlight") then
    utils.augroup("user_lsp_document_highlight", {
      {
        desc = "highlight references when cursor holds",
        event = { "CursorHold", "CursorHoldI" },
        buffer = bufnr,
        command = function()
          if
            not utils.lsp.has_capability(
              "textDocument/documentHighlight",
              { bufnr = bufnr }
            )
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

  -- Call additional attach handlers
  for _, h in ipairs(require("utils.lsp").attach_handlers) do
    h(client, bufnr)
  end
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = vim.tbl_deep_extend("force", default_capabilities, {
  textDocument = {
    completion = {
      dynamicRegistration = false,
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        preselectSupport = true,
        tagSupport = {
          valueSet = {
            1, -- Deprecated
          },
        },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
        insertTextModeSupport = {
          valueSet = {
            1, -- asIs
            2, -- adjustIndentation
          },
        },
        labelDetailsSupport = true,
      },
      contextSupport = true,
      insertTextMode = 1,
      completionList = {
        itemDefaults = {
          "commitCharacters",
          "editRange",
          "insertTextFormat",
          "insertTextMode",
          "data",
        },
      },
    },
  },
})

local flags = {
  debounce_text_changes = 150,
}

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = flags,
}
