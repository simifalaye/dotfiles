if vim.fn.executable("fzf") < 1 then
  return
end

-- Use fzf-lua for ui-select
require("fzf-lua").register_ui_select()

-- Keymaps
vim.keymap.set(
  "n",
  "<leader>b",
  "<cmd>FzfLua buffers sort_mru=true<CR>",
  { desc = "Open Buffer Picker" }
)
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>", { desc = "Open File Picker" })
vim.keymap.set(
  "n",
  "<leader>F",
  "<cmd>FzfLua git_files<CR>",
  { desc = "Open File Picker (Git)" }
)
vim.keymap.set(
  "n",
  "<leader>d",
  "<cmd>FzfLua diagnostics_document<CR>",
  { desc = "Open Diagnostics Picker (Doc)" }
)
vim.keymap.set(
  "n",
  "<leader>D",
  "<cmd>FzfLua diagnostics_workspace<CR>",
  { desc = "Open Diagnostics Picker (Work)" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  "<cmd>FzfLua quickfix<CR>",
  { desc = "Open Quickfix Picker" }
)
vim.keymap.set(
  "n",
  "<leader>s",
  "<cmd>FzfLua lsp_document_symbols<CR>",
  { desc = "Open Symbol Picker (Doc)" }
)
vim.keymap.set(
  "n",
  "<leader>S",
  "<cmd>FzfLua lsp_workspace_symbols<CR>",
  { desc = "Open Symbol Picker (Work)" }
)
vim.keymap.set(
  "n",
  "<leader>;",
  "<cmd>FzfLua command_history<CR>",
  { desc = "Open Command History Picker" }
)
vim.keymap.set(
  "n",
  "<leader>:",
  "<cmd>FzfLua commands<CR>",
  { desc = "Open Commands Picker" }
)
vim.keymap.set("n", "<leader>'", "<cmd>FzfLua marks<CR>", { desc = "Open Marks Picker" })
vim.keymap.set(
  "n",
  '<leader>"',
  "<cmd>FzfLua registers<CR>",
  { desc = "Open Registers Picker" }
)
vim.keymap.set(
  "n",
  "<leader><CR>",
  "<cmd>FzfLua<CR>",
  { desc = "Open Picker Command Palette" }
)
vim.keymap.set(
  "n",
  "<leader>,",
  "<cmd>FzfLua oldfiles cwd_only=true<CR>",
  { desc = "Open Recents Picker (cwd)" }
)
vim.keymap.set(
  "n",
  "<leader><",
  "<cmd>FzfLua oldfiles<CR>",
  { desc = "Open Recents Picker" }
)
vim.keymap.set("n", "<leader>.", "<cmd>FzfLua resume<CR>", { desc = "Picker Resume" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<CR>", { desc = "Global Search" })
vim.keymap.set(
  "n",
  "<leader>?",
  "<cmd>FzfLua helptags<CR>",
  { desc = "Open Help Picker" }
)
