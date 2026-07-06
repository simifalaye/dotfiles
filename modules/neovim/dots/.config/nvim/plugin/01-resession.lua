vim.pack.add({
  {
    src = "https://github.com/folke/snacks.nvim.git",
  },
})
require("snacks").setup({
  picker = { enabled = true, layout = "vertical" },
})

vim.pack.add({
  {
    src = "https://github.com/stevearc/resession.nvim",
  },
})

local resession = require("resession")
resession.setup({
  -- Options for automatically saving sessions on a timer
  autosave = {
    enabled = false,
    -- How often to save (in seconds)
    interval = 60,
    -- Notify when autosaved
    notify = true,
  },
  -- Save and restore these options
  options = {
    "binary",
    "bufhidden",
    "buflisted",
    "cmdheight",
    "diff",
    "filetype",
    "modifiable",
    "previewwindow",
    "readonly",
    "scrollbind",
    "winfixheight",
    "winfixwidth",
  },
  buf_filter = function(bufnr)
    -- Don't save terminal buffers
    if vim.bo[bufnr].buftype == "terminal" then
      return false
    end
    return require("resession").default_buf_filter(bufnr)
  end,
  -- Custom logic for determining if a buffer should be included in a tab-scoped session
  tab_buf_filter = function(_, _)
    return true
  end,
  -- The name of the directory to store sessions in
  dir = "session",
  -- Show more detail about the sessions when selecting one to load.
  -- Disable if it causes lag.
  load_detail = true,
  -- List order ["modification_time", "creation_time", "filename"]
  load_order = "modification_time",
  -- Configuration for extensions
  extensions = {
    quickfix = {},
  },
})

-- vim.keymap.set("n", "<leader>qd", resession.delete, { desc = "Delete Session" })
-- vim.keymap.set("n", "<leader>qL", resession.load, { desc = "Load Session" })
-- vim.keymap.set("n", "<leader>qs", resession.save, { desc = "Save Session" })
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- Only load the session if nvim was started with no args and without reading from stdin
--     if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
--       resession.load(vim.fn.getcwd(), { silence_errors = true })
--     end
--   end,
--   nested = true,
-- })
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     resession.save(vim.fn.getcwd(), { notify = false })
--   end,
-- })
-- vim.api.nvim_create_autocmd("StdinReadPre", {
--   callback = function()
--     -- Store this for later
--     vim.g.using_stdin = true
--   end,
-- })
