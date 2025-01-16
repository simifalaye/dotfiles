local timer = vim.loop.new_timer()
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local file_utilities_groupid = augroup("user_file_utilities", {})
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = file_utilities_groupid,
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
  group = file_utilities_groupid,
  pattern = "*",
  callback = function(event)
    local exclude = { "gitcommit", "popup" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed",
  group = file_utilities_groupid,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

local window_behaviours_groupid = augroup("user_window_behaviours", {})
autocmd("VimResized", {
  desc = "Auto-resize splits",
  group = window_behaviours_groupid,
  pattern = { "*" },
  command = "tabdo wincmd =",
})
autocmd("WinEnter", {
  desc = "Show cursorline when focused",
  group = window_behaviours_groupid,
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd("WinLeave", {
  desc = "Hide cursorline when un-focused",
  group = window_behaviours_groupid,
  callback = function()
    vim.wo.cursorline = false
  end,
})
autocmd({ "CursorMoved", "CursorMovedI" }, {
  desc = "Show cursorline when cursor is not moved for some time",
  group = window_behaviours_groupid,
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

local yank_text_groupid = augroup("user_yank_text", {})
autocmd({ "VimEnter", "CursorMoved" }, {
  desc = "Save cursor position whenever it moves",
  group = yank_text_groupid,
  pattern = "*",
  callback = function()
    vim.g.user_cursor_pos = vim.fn.getpos(".")
  end,
})
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = yank_text_groupid,
  callback = function()
    vim.highlight.on_yank({ timeout = 200, higroup = "IncSearch" })
  end,
})
autocmd("TextYankPost", {
  desc = "Restore cursor position after yank",
  group = yank_text_groupid,
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setpos(".", vim.g.user_cursor_pos)
    end
  end,
})

autocmd({ "LspAttach" }, {
  group = augroup("user_lsp_setup", {}),
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
    --
    -- NORMAL MODE
    -- K        : hover
    -- CTRL-]   : definition
    -- CTRL-W_] : definition in new window
    -- CTRL-W_} : definition in preview window
    -- ]d       : next diagnostic
    -- [d       : prev diagnostic
    -- CTRL-W_d : open diagnostic float
    --
    -- VISUAL MODE
    -- gq : format
    --
    -- INSERT MODE
    -- CTRL-S        : signature help
    -- CTRL-X_CTRL-O : completion
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({ { "gr", group = "+lsp" } }, { buffer = bufnr })
      wk.add({ { "grw", group = "+workspace" } }, { buffer = bufnr })
    end
    local keys = {
      {
        "gQ",
        function()
          if vim.b[bufnr].user_lsp_preferred_format_server then
            vim.lsp.buf.format({ name = vim.b[bufnr].user_lsp_preferred_format_server })
            return
          end
          vim.lsp.buf.format()
        end,
        desc = "Format Buffer (lsp)",
        has = "documentFormatting",
      },
      {
        "gra",
        vim.lsp.buf.code_action,
        desc = "Code Action (lsp)",
        mode = { "n", "v" },
        has = "codeAction",
      },
      {
        "grd",
        vim.lsp.buf.declaration,
        desc = "Goto Dec (lsp)",
        has = "declaration",
      },
      {
        "gri",
        vim.lsp.buf.implementation,
        desc = "Goto Impl (lsp)",
        has = "implementation",
      },
      {
        "grI",
        function()
          vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
            { bufnr = bufnr }
          )
        end,
        desc = "Toggle inlay hints (lsp)",
        has = "inlayHint",
      },
      {
        "grl",
        function()
          vim.lsp.codelens.refresh()
        end,
        desc = "Codelens refresh (lsp)",
        has = "codeLens",
      },
      {
        "grL",
        function()
          vim.lsp.codelens.run()
        end,
        desc = "Codelens run (lsp)",
        has = "codeLens",
      },
      {
        "grn",
        vim.lsp.buf.rename,
        desc = "Rename (lsp)",
        has = "rename",
      },
      {
        "grr",
        vim.lsp.buf.references,
        desc = "References (lsp)",
        has = "references",
      },
      {
        "grs",
        vim.lsp.buf.signature_help,
        desc = "Signature (lsp)",
        has = "signatureHelp",
      },
      {
        "grt",
        vim.lsp.buf.type_definition,
        desc = "Goto Type (lsp)",
        has = "typeDefinition",
      },
      {
        "grwa",
        vim.lsp.buf.add_workspace_folder,
        desc = "Add Folder (lsp)",
      },
      {
        "grwr",
        vim.lsp.buf.remove_workspace_folder,
        desc = "Remove Folder (lsp)",
      },
      {
        "grwl",
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = "List Folders (lsp)",
      },
    }

    -- Register lsp keys
    require("utils.lsp").register_keys(client, bufnr, keys)

    -- Configure additional client functions
    if
      client.supports_method("textDocument/codeLens") and vim.g.user_lsp_codelens_enabled
    then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_codelens_refresh", {}),
        buffer = bufnr,
        callback = function()
          if vim.g.user_lsp_codelens_enabled then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
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
        vim.b["user_semantic_tokens_enabled"] = vim.g.user_lsp_semantic_tokens_enabled
      end
      vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
        bufnr,
        client.id
      )
    end
    if
      client.supports_method("textDocument/documentHighlight")
      and vim.g.user_lsp_reference_highlight_enabled
    then
      local doc_highlight_groupid = vim.api.nvim_create_augroup("user_doc_highlight", {})
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = doc_highlight_groupid,
        desc = "highlight references when cursor holds",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = doc_highlight_groupid,
        desc = "Clear references when cursor moves",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
    if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
      if vim.b.user_inlay_hints_enabled == nil then
        vim.b.user_inlay_hints_enabled = vim.g.user_lsp_inlay_hints_enabled
      end
      if vim.b.user_inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
  end,
})
