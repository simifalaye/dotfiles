local timer = vim.uv.new_timer()
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local file_utilities_grpid = augroup("user_file_utilities", {})
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = file_utilities_grpid,
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local ignore = { "ruby", "perl", "markdown", "gitsendemail", "gitcommit" }
    for _, val in ipairs(ignore) do
      if string.match(ft, val) then
        return
      end
    end
    vim.cmd([[ %s/\s\+$//e ]])
  end,
})
autocmd("BufReadPost", {
  desc = "Jump to last known position and center buffer around cursor",
  group = file_utilities_grpid,
  pattern = "*",
  callback = function(event)
    local exclude = { "gitcommit", "popup" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
      return
    end
    vim.b[buf].user_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed",
  group = file_utilities_grpid,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("silent! checktime")
    end
  end,
})

local window_behaviours_grpid = augroup("user_window_behaviours", {})
autocmd("VimResized", {
  desc = "Auto-resize splits",
  group = window_behaviours_grpid,
  pattern = { "*" },
  command = "tabdo wincmd =",
})
autocmd("WinEnter", {
  desc = "Show cursorline when focused",
  group = window_behaviours_grpid,
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd("WinLeave", {
  desc = "Hide cursorline when un-focused",
  group = window_behaviours_grpid,
  callback = function()
    vim.wo.cursorline = false
  end,
})
autocmd({ "CursorMoved", "CursorMovedI" }, {
  desc = "Show cursorline when cursor is not moved for some time",
  group = window_behaviours_grpid,
  callback = function()
    if not timer then
      return
    end
    vim.wo.cursorlineopt = "number"
    timer:start(
      1000, -- default timeout
      0,
      vim.schedule_wrap(function()
        vim.wo.cursorlineopt = "both"
      end)
    )
  end,
})

local yank_text_grpid = augroup("user_yank_text", {})
autocmd({ "VimEnter", "CursorMoved" }, {
  desc = "Save cursor position whenever it moves",
  group = yank_text_grpid,
  pattern = "*",
  callback = function()
    vim.g.user_cursor_pos = vim.fn.getpos(".")
  end,
})
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = yank_text_grpid,
  callback = function()
    vim.highlight.on_yank({ timeout = 200, higroup = "IncSearch" })
  end,
})
autocmd("TextYankPost", {
  desc = "Restore cursor position after yank",
  group = yank_text_grpid,
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setpos(".", vim.g.user_cursor_pos)
    end
  end,
})

local lsp_setup_grpid = augroup("user_lsp_setup", {})
autocmd({ "LspAttach" }, {
  group = lsp_setup_grpid,
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
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({ { "gr", group = "+lsp" } }, { buffer = bufnr })
      wk.add({ { "grw", group = "+workspace" } }, { buffer = bufnr })
    end
    vim.keymap.set("n", "grwa", vim.lsp.buf.add_workspace_folder, { desc = "Add Folder (lsp)", buffer = bufnr })
    vim.keymap.set("n", "grwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Folder (lsp)", buffer = bufnr })
    vim.keymap.set("n", "grwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { desc = "List Folders (lsp)", buffer = bufnr })

    local supports_method = function(method)
      return client:supports_method("textDocument/" .. method)
    end

    -- Additional configuration based on supported methods
    if supports_method("documentFormatting") then
      vim.keymap.set("n", "gQ", vim.lsp.buf.format, { desc = "Format Buffer (lsp)", buffer = bufnr })
    end
    if supports_method("declaration") then
      vim.keymap.set("n", "grd", vim.lsp.buf.declaration, { desc = "Goto Dec (lsp)", buffer = bufnr })
    end
    if supports_method("inlayHint") then
      vim.keymap.set("n",
        "grI",
        function()
          vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
            { bufnr = bufnr }
          )
        end,
        { desc = "Toggle inlay hints (lsp)", buffer = bufnr }
      )
    end
    if supports_method("codeLens") and vim.g.user_lsp_codelens_enabled then
      vim.keymap.set("n",
        "grl",
        function()
          vim.lsp.codelens.refresh()
        end,
        { desc = "Codelens refresh (lsp)", buffer = bufnr }
      )
      vim.keymap.set("n",
        "grL",
        function()
          vim.lsp.codelens.run()
        end,
        { desc = "Codelens run (lsp)", buffer = bufnr }
      )
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = augroup("user_codelens_refresh", { clear = false }),
        buffer = bufnr,
        callback = function()
          if vim.g.user_lsp_codelens_enabled then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end
        end,
      })
    end
    if supports_method("signatureHelp") then
      vim.keymap.set("n",
        "grs",
        vim.lsp.buf.signature_help,
        { desc = "Signature (lsp)", buffer = bufnr }
      )
    end
    if supports_method("typeDefinition") then
      vim.keymap.set("n",
        "grt",
        vim.lsp.buf.type_definition,
        { desc = "Goto Type (lsp)", buffer = bufnr }
      )
    end
    if
        (
          supports_method("semanticTokens/full")
          or supports_method("semanticTokens/full/delta")
        ) and vim.lsp.semantic_tokens
    then
      if vim.b["user_semantic_tokens_enabled"] == nil then
        vim.b["user_semantic_tokens_enabled"] = vim.g.user_lsp_semantic_tokens_enabled
      end
      vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
        bufnr,
        client.id
      )
    end
    if
        supports_method("documentHighlight")
        and vim.g.user_lsp_reference_highlight_enabled
    then
      local doc_highlight_grpid = augroup("user_doc_highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = doc_highlight_grpid,
        desc = "highlight references when cursor holds",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = doc_highlight_grpid,
        desc = "Clear references when cursor moves",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
    if supports_method("inlayHint") and vim.lsp.inlay_hint then
      if vim.b.user_inlay_hints_enabled == nil then
        vim.b.user_inlay_hints_enabled = vim.g.user_lsp_inlay_hints_enabled
      end
      if vim.b.user_inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
    -- if supports_method("completion") then
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end
  end,
})
