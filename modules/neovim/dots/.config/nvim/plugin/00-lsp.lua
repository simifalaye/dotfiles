vim.lsp.config("*", {
  root_markers = require("utils.fs").root_patterns,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
})

vim.lsp.enable({
  "bashls",
  "clangd",
  "fish_lsp",
  "gopls",
  "jsonls",
  "lua_ls",
  "nil_ls",
  "pyright",
  "rust_analyzer",
  "yamlls",
})

local lsp_setup_grp = vim.api.nvim_create_augroup("user_lsp_setup", {})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = lsp_setup_grp,
  desc = "Setup buffer-local lsp configuration on attach",
  callback = function(args)
    local bufnr = args.buf --[[@as number]]
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    -- Enable lsp omnifunc and tagfunc for completion and goto def
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- Setup main keymaps
    -- :h lsp-defaults
    vim.keymap.set(
      "n",
      "grwa",
      vim.lsp.buf.add_workspace_folder,
      { desc = "Add Folder (lsp)", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "grwr",
      vim.lsp.buf.remove_workspace_folder,
      { desc = "Remove Folder (lsp)", buffer = bufnr }
    )
    vim.keymap.set("n", "grwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "List Folders (lsp)", buffer = bufnr })

    local supports_method = function(method)
      return client:supports_method("textDocument/" .. method)
    end

    -- Additional configuration based on supported methods
    if supports_method("declaration") then
      vim.keymap.set(
        "n",
        "grd",
        vim.lsp.buf.declaration,
        { desc = "Goto Dec (lsp)", buffer = bufnr }
      )
    end
    if supports_method("codeLens") and not vim.g.user_lsp_codelens_disable then
      vim.keymap.set("n", "grl", function()
        vim.lsp.codelens.refresh()
      end, { desc = "Codelens refresh (lsp)", buffer = bufnr })
      vim.keymap.set("n", "grL", function()
        vim.lsp.codelens.run()
      end, { desc = "Codelens run (lsp)", buffer = bufnr })
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_codelens_refresh", { clear = false }),
        buffer = bufnr,
        callback = function()
          if not vim.b.user_lsp_codelens_disable then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end
        end,
      })
    end
    if supports_method("signatureHelp") then
      vim.keymap.set(
        "n",
        "grs",
        vim.lsp.buf.signature_help,
        { desc = "Signature (lsp)", buffer = bufnr }
      )
    end
    if supports_method("typeDefinition") then
      vim.keymap.set(
        "n",
        "grt",
        vim.lsp.buf.type_definition,
        { desc = "Goto Type (lsp)", buffer = bufnr }
      )
    end
    if
      (
        supports_method("semanticTokens/full")
        or supports_method("semanticTokens/full/delta")
      )
      and vim.lsp.semantic_tokens
      and not vim.g.user_lsp_semantic_tokens_disable
    then
      if not vim.b.user_lsp_semantic_tokens_disable then
        if vim.fn.has("nvim-0.12") == 1 then
          vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
        else
          vim.lsp.semantic_tokens["start"](bufnr, client.id)
        end
      end
    end
    if supports_method("documentHighlight") then
      local doc_highlight_grp =
        vim.api.nvim_create_augroup("user_doc_highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = doc_highlight_grp,
        desc = "highlight references when cursor holds",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = doc_highlight_grp,
        desc = "Clear references when cursor moves",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
    if
      supports_method("inlayHint")
      and vim.lsp.inlay_hint
      and not vim.g.user_lsp_inlay_hints_disable
    then
      if not vim.b.user_lsp_inlay_hints_disable then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
    -- if supports_method("completion") then
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end
  end,
})
