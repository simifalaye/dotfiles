MiniDeps.add({
  source = "rmagatti/auto-session",
})

MiniDeps.now(function()
  -- Set session options
  vim.o.sessionoptions =
    "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  -- Load plugin
  local autosession = require("auto-session")
  local first_restore = true
  autosession.setup({
    enabled = true,
    root_dir = vim.fn.stdpath("data") .. "/sessions/",
    auto_save = true,
    auto_restore = true,
    auto_create = false,
    suppressed_dirs = nil,
    allowed_dirs = nil,
    auto_restore_last_session = false,
    git_use_branch_name = false,
    git_auto_restore_on_branch_change = false,
    lazy_support = true,
    bypass_save_filetypes = nil,
    close_filetypes_on_save = { "checkhealth" },
    close_unsupported_windows = true,
    preserve_buffer_on_restore = function(bufnr)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      local bt = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" and ft == "" and bt == "terminal" then
        return true
      end
      return false
    end,
    args_allow_single_directory = true,
    args_allow_files_auto_save = false,
    continue_restore_on_error = true,
    show_auto_restore_notif = false,
    cwd_change_handling = true,
    single_session_mode = false,
    lsp_stop_on_restore = true,
    restore_error_handler = nil,
    purge_after_minutes = nil,
    log_level = "error",
    pre_restore_cmds = {
      function()
        if first_restore then
          first_restore = false
          return
        end
        autosession.SaveSession(nil, false)
      end,
    },
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>qd", "<cmd>SessionDelete<CR>", { desc = "Delete" })
  vim.keymap.set("n", "<leader>ql", function()
    local latest_session =
      require("auto-session.lib").get_latest_session(autosession.get_root_dir())
    autosession.RestoreSession(latest_session)
  end, { desc = "Restore latest" })
  vim.keymap.set("n", "<leader>qr", "<cmd>SessionRestore<CR>", { desc = "Restore" })
  vim.keymap.set("n", "<leader>qs", "<cmd>SessionSearch<CR>", { desc = "Search" })
  vim.keymap.set("n", "<leader>qw", "<cmd>SessionSave<CR>", { desc = "Write" })
end)
