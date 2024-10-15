local telescope = require("telescope")
local actions = require("telescope.actions") ---@module 'telescope.actions'
local themes = require("telescope.themes") ---@module 'telescope.themes'

-- Setup plugin
telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "truncate" },
    layout_strategy = "flex",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      vertical = { prompt_position = "top", mirror = false },
      flex = { prompt_position = "top" },
      width = 0.87,
      height = 0.80,
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        -- ["<Esc>"] = actions.close,
        -- ["<C-h>"] = actions.preview_scrolling_left,
        -- ["<C-j>"] = actions.preview_scrolling_down,
        -- ["<C-k>"] = actions.preview_scrolling_up,
        -- ["<C-l>"] = actions.preview_scrolling_right,
        -- ["<C-Down>"] = actions.cycle_history_next,
        -- ["<C-Up>"] = actions.cycle_history_prev,
        -- ["<C-s>"] = actions.select_horizontal,
        -- ["<c-x>"] = false,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = function(...)
          actions.smart_send_to_qflist(...)
          actions.open_qflist(...)
        end,
        ["<CR>"] = actions.select_default,
      },
      n = {
        -- ["<Esc>"] = actions.close,
        -- ["<C-h>"] = actions.preview_scrolling_left,
        -- ["<C-l>"] = actions.preview_scrolling_right,
        -- ["<C-Down>"] = actions.cycle_history_next,
        -- ["<C-Up>"] = actions.cycle_history_prev,
        -- ["<C-s>"] = actions.select_horizontal,
        -- ["<c-x>"] = false,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<C-q>"] = function(...)
          actions.smart_send_to_qflist(...)
          actions.open_qflist(...)
        end,
      },
    },
    -- open files in the first window that is an actual file.
    -- use the current window if no other window is available.
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
  },
  extensions = {
    ["ui-select"] = {
      themes.get_dropdown(),
    },
    ["zf-native"] = {
      -- options for sorting file-like items
      file = {
        -- override default telescope file sorter
        enable = true,
        -- highlight matching text in results
        highlight_results = true,
        -- enable zf filename match priority
        match_filename = true,
        -- optional function to define a sort order when the query is empty
        initial_sort = nil,
        -- set to false to enable case sensitive matching
        smart_case = true,
      },
      -- options for sorting all other items
      generic = {
        -- override default telescope generic item sorter
        enable = true,
        -- highlight matching text in results
        highlight_results = true,
        -- disable zf filename match priority
        match_filename = false,
        -- optional function to define a sort order when the query is empty
        initial_sort = nil,
        -- set to false to enable case sensitive matching
        smart_case = true,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      mappings = {
        n = {
          ["x"] = actions.delete_buffer,
        },
      },
    },
  },
})

-- Enable Telescope extensions if they are installed
pcall(telescope.load_extension, "zf-native")
pcall(telescope.load_extension, "ui-select")

-- Keymaps
vim.keymap.set(
  "n",
  "<leader>b",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Open Buffer Picker" }
)
vim.keymap.set(
  "n",
  "<leader>f",
  "<cmd>Telescope find_files<CR>",
  { desc = "Open File Picker" }
)
vim.keymap.set(
  "n",
  "<leader>F",
  "<cmd>Telescope find_files no_ignore=true<CR>",
  { desc = "Open File Picker (All)" }
)
vim.keymap.set(
  "n",
  "<leader>d",
  "<cmd>Telescope diagnostics<CR>",
  { desc = "Open Diagnostics Picker" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  "<cmd>Telescope quickfix<CR>",
  { desc = "Open Quickfix Picker" }
)
vim.keymap.set(
  "n",
  "<leader>s",
  "<cmd>Telescope lsp_document_symbols<CR>",
  { desc = "Open Symbol Picker (Document)" }
)
vim.keymap.set(
  "n",
  "<leader>S",
  "<cmd>Telescope lsp_workspace_symbols<CR>",
  { desc = "Open Symbol Picker (Workspace)" }
)
vim.keymap.set(
  "n",
  "<leader>;",
  "<cmd>Telescope command_history<CR>",
  { desc = "Open Command History Picker" }
)
vim.keymap.set(
  "n",
  "<leader>:",
  "<cmd>Telescope commands<CR>",
  { desc = "Open Commands Picker" }
)
vim.keymap.set(
  "n",
  "<leader>'",
  "<cmd>Telescope marks<CR>",
  { desc = "Open Marks Picker" }
)
vim.keymap.set(
  "n",
  '<leader>"',
  "<cmd>Telescope registers<CR>",
  { desc = "Open Registers Picker" }
)
vim.keymap.set(
  "n",
  "<leader><CR>",
  "<cmd>Telescope builtin<CR>",
  { desc = "Open Picker Command Palette" }
)
vim.keymap.set(
  "n",
  "<leader>,",
  "<cmd>Telescope oldfiles cwd_only=true<CR>",
  { desc = "Open Recents Picker (cwd)" }
)
vim.keymap.set(
  "n",
  "<leader><",
  "<cmd>Telescope oldfiles<CR>",
  { desc = "Open Recents Picker" }
)
vim.keymap.set("n", "<leader>.", "<cmd>Telescope resume<CR>", { desc = "Picker Resume" })
vim.keymap.set(
  "n",
  "<leader>/",
  "<cmd>Telescope live_grep<CR>",
  { desc = "Global Search" }
)
vim.keymap.set(
  "n",
  "<leader>?",
  "<cmd>Telescope help_tags<CR>",
  { desc = "Open Help Picker" }
)

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end
vim.keymap.set(
  "n",
  "<leader>gb",
  "<cmd>Telescope git_branches<CR>",
  { desc = "Branches" }
)
vim.keymap.set(
  "n",
  "<leader>gc",
  "<cmd>Telescope git_bcommits<CR>",
  { desc = "Commits (buf)" }
)
vim.keymap.set(
  "n",
  "<leader>gC",
  "<cmd>Telescope git_commits<CR>",
  { desc = "Commits (repo)" }
)
vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Files" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
vim.keymap.set("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Stash" })
