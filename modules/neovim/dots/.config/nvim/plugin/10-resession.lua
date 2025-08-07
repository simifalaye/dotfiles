local deps = require("mini.deps")

vim.g.user_auto_session_enabled = vim.g.user_auto_session_enabled or true

deps.add({
  source = "stevearc/resession.nvim",
})

deps.now(function()
  local last_session
  local get_session_dir = function()
    return vim.fs.root(0, require("utils.fs").root_patterns)
  end

  local opts = {
    autosave = {
      enabled = true,
      interval = 60,
      notify = false,
    },
    extensions = {},
  }
  local overseer_ok, _ = pcall(require, "overseer")
  if overseer_ok then
    vim.tbl_deep_extend("force", opts.extensions, { overseer = {} })
  end

  -- Load plugin
  local resession = require("resession")
  resession.setup(opts)
  resession.add_hook("pre_load", function()
    if not vim.g.user_auto_session_enabled then
      return
    end
    -- Save session when loading a new session (only if currently in a session)
    if resession.get_current() then
      last_session = resession.get_current()
      resession.save(nil, { notify = false })
    end
  end)

  -- Autocmds
  local grp = vim.api.nvim_create_augroup("user_plugin_resession", {})
  vim.api.nvim_create_autocmd("StdinReadPre", {
    desc = "Save stdin read status",
    group = grp,
    callback = function()
      -- Store this for later
      vim.g.using_stdin = true
    end,
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Automatically load session for the current directory",
    group = grp,
    callback = function()
      if not vim.g.user_auto_session_enabled then
        return
      end
      -- Only load the session if nvim was started with no args and without reading from stdin
      if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
        local session_dir = get_session_dir()
        if session_dir then
          resession.load(session_dir, { silence_errors = true })
        end
      end
    end,
    nested = true,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "Save session on exit",
    group = grp,
    callback = function()
      if not vim.g.user_auto_session_enabled then
        return
      end
      -- Save session on exit (only if currently in a session)
      if resession.get_current() then
        resession.save(nil, { notify = false })
      end
    end,
  })

  -- Setup wk group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>s", group = "+Session" } })
  end

  -- Setup keymaps
  vim.keymap.set("n", "<leader>s<Tab>", function()
    if last_session then
      resession.load(last_session)
    end
  end, { desc = "Last" })
  vim.keymap.set("n", "<leader>ss", function()
    resession.save(get_session_dir())
  end, { desc = "Save" })
  vim.keymap.set("n", "<leader>sl", resession.load, { desc = "Load" })
  vim.keymap.set("n", "<leader>sd", resession.delete, { desc = "Delete" })
end)
