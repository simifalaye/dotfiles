-- Set default lsp config
vim.lsp.config("*", {
  root_markers = require("utils.fs").root_patterns,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
})

exec_now_if_args(function()
  -- Load additionl lsp configurations
  vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
  })

  -- Setup lsp attach handler for keymaps and settings
  local lsp_grp = vim.api.nvim_create_augroup("user.lsp", {})
  vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = lsp_grp,
    desc = "Setup buffer-local lsp configuration on attach",
    callback = function(args)
      local bufnr = args.buf --[[@as number]]
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
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
      if supports_method("formatting") then
        vim.keymap.set("n", "grf", function()
          vim.lsp.buf.format({ bufnr = args.buf })
        end, { desc = "vim.lsp.buf.format()", buffer = bufnr })
      end
      if supports_method("rangesFormatting") then
        vim.keymap.set("x", "grf", function()
          vim.lsp.buf.format({ bufnr = args.buf })
        end, {
          desc = "vim.lsp.buf.format()",
          buffer = bufnr,
        })
      end
      if supports_method("declaration") then
        vim.keymap.set(
          "n",
          "grd",
          vim.lsp.buf.declaration,
          { desc = "Goto Dec (lsp)", buffer = bufnr }
        )
      end
      if supports_method("codeLens") and not vim.g.user_lsp_codelens_disable then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          group = vim.api.nvim_create_augroup("user.lsp.codelens", { clear = false }),
          buffer = bufnr,
          callback = function()
            if not vim.b.user_lsp_codelens_disable then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end
          end,
        })
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
            vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr, client_id = client.id })
          end
        end
      end
      if supports_method("documentHighlight") then
        local doc_highlight_grp =
          vim.api.nvim_create_augroup("user.lsp.doc_highlight", { clear = false })
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
      if supports_method("completion") then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      end
    end,
  })

  -- -- Display lsp progress
  -- vim.api.nvim_create_autocmd("LspProgress", {
  --   group = lsp_grp,
  --   callback = function(ev)
  --     local value = ev.data.params.value
  --     vim.api.nvim_echo({ { value.message or "done" } }, false, {
  --       id = "lsp." .. ev.data.client_id,
  --       kind = "progress",
  --       source = "vim.lsp",
  --       title = value.title,
  --       status = value.kind ~= "end" and "running" or "success",
  --       percent = value.percentage,
  --     })
  --   end,
  -- })
end)
