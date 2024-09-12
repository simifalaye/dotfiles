local api = vim.api
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
  callback = function()
    if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
      local last_place_mark = api.nvim_buf_get_mark(0, '"')
      local line_nr = last_place_mark[1]
      local last_line = api.nvim_buf_line_count(0)

      if line_nr > 0 and line_nr <= last_line then
        api.nvim_win_set_cursor(0, last_place_mark)
      end
    end
  end,
})
autocmd("BufReadPre", {
  desc = "Set settings for large files.",
  group = file_utilities_groupid,
  callback = function(info)
    vim.b["midfile"] = false
    vim.b["bigfile"] = false
    local ok, stat = pcall(vim.loop.fs_stat, info.match)
    if not ok then
      return
    end
    local large_file_groupid = augroup("user_large_file", {})
    if stat and stat.size > 48000 then
      vim.b["midfile"] = true
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = large_file_groupid,
        buffer = info.buf,
        once = true,
        callback = function()
          vim.schedule(function()
            pcall(vim.treesitter.stop, info.buf)
          end)
        end,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = large_file_groupid,
        buffer = info.buf,
        callback = function(args)
          vim.schedule(function()
            vim.lsp.buf_detach_client(info.buf, args.data.client_id)
          end)
        end,
      })
    end
    if stat and stat.size > 1024000 then
      vim.b["bigfile"] = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = large_file_groupid,
        buffer = info.buf,
        once = true,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
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

autocmd({ "BufWinEnter", "FileChangedShellPost" }, {
  group = augroup("user_auto_cwd", {}),
  desc = "Automatically change local current directory.",
  pattern = "*",
  callback = function(info)
    if not vim.g.user_rooter_enabled then
      return
    end
    if info.file == "" or vim.bo[info.buf].bt ~= "" then
      return
    end
    local buf = info.buf
    local win = vim.api.nvim_get_current_win()

    vim.schedule(function()
      if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or not vim.api.nvim_win_get_buf(win) == buf
      then
        return
      end
      vim.api.nvim_win_call(win, function()
        local current_dir = vim.fn.getcwd(0)
        local target_dir = vim.fs.root(info.file, require("utils.fs").root_patterns)
          or vim.fs.dirname(info.file)
        local stat = target_dir and vim.uv.fs_stat(target_dir)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if stat and stat.type == "directory" and current_dir ~= target_dir then
          vim.notify("Changing current dir: " .. target_dir, vim.log.levels.DEBUG)
          pcall(vim.cmd.lcd, target_dir)
        end
      end)
    end)
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
      client.supports_method("textDocument/codeLens")
      and vim.g.user_codelens_enabled
    then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = augroup("user_codelens_refresh", {}),
        buffer = bufnr,
        callback = function()
          if vim.g.user_codelens_enabled then
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
        vim.b["user_semantic_tokens_enabled"] = vim.g.user_semantic_tokens_enabled
      end
      vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
        bufnr,
        client.id
      )
    end
    if client.supports_method("textDocument/documentHighlight") then
      local doc_highlight_groupid = augroup("user_doc_highlight", {})
      autocmd({ "CursorHold", "CursorHoldI" }, {
        group = doc_highlight_groupid,
        desc = "highlight references when cursor holds",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      autocmd({ "CursorMoved", "CursorMovedI" }, {
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
        vim.b.user_inlay_hints_enabled = vim.g.user_inlay_hints_enabled
      end
      if vim.b.user_inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
  end,
})

local diagnostics_groupid = augroup("user_diagnostics", {})
local diagnostic_float_win_id = nil
autocmd({ "CursorHold" }, {
  group = diagnostics_groupid,
  desc = "Show diagnostics on cursor hold",
  callback = function()
    if not vim.g.user_diagnostic_hover then
      return
    end
    if diagnostic_float_win_id ~= nil then
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1], cursor_pos[2]

    -- Get the diagnostics for the current line and column
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = row - 1 })
    if not diagnostics or #diagnostics == 0 then
      return
    end

    -- Check if there are any diagnostics
    local msg = ""
    for _, diag in ipairs(diagnostics) do
      if
        diag.lnum == row - 1
        and diag.col <= col
        and (diag.end_col == nil or diag.end_col >= col)
      then
        if string.len(msg) > 0 then
          msg = msg .. "\n"
        end
        msg = msg .. diag.message
      end
    end
    if string.len(msg) > 0 then
      local lines = vim.split(msg, "\n")
      -- Calculate the width and height required
      local height = #lines
      local width = 0
      -- Determine the maximum width of any line
      for _, line in ipairs(lines) do
        width = math.max(width, #line)
      end
      -- Create a floating window
      diagnostic_float_win_id =
        vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
          relative = "editor",
          width = width,
          height = height,
          anchor = "NE",
          col = vim.o.columns,
          row = 0,
          style = "minimal",
          border = { { " ", "NormalFloat" } },
          -- border = {
          --   { "╭", "NormalFloat" },
          --   { "─", "NormalFloat" },
          --   { "╮", "NormalFloat" },
          --   { "│", "NormalFloat" },
          --   { "╯", "NormalFloat" },
          --   { "─", "NormalFloat" },
          --   { "╰", "NormalFloat" },
          --   { "│", "NormalFloat" },
          -- },
        })

      -- Set buffer content and highlight
      local buf = vim.api.nvim_win_get_buf(diagnostic_float_win_id)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
      vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    end
  end,
})
autocmd({ "CursorMoved", "BufLeave", "WinLeave" }, {
  group = diagnostics_groupid,
  desc = "Clear diagnostics on cursor move",
  callback = function()
    if diagnostic_float_win_id ~= nil then
      pcall(vim.api.nvim_win_close, diagnostic_float_win_id, false)
      diagnostic_float_win_id = nil
    end
  end,
})

