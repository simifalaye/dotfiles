local lz = require("utils.lazy").new("telescope", function()
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
          ["<Esc>"] = actions.close,
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-s>"] = actions.select_horizontal,
          ["<c-x>"] = false,
        },
        n = {
          ["<Esc>"] = actions.close,
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-s>"] = actions.select_horizontal,
          ["<c-x>"] = false,
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
          i = {
            ["<c-x>"] = actions.delete_buffer,
          },
          n = {
            ["<c-x>"] = actions.delete_buffer,
          },
        },
      },
    },
  })
  -- Enable Telescope extensions if they are installed
  pcall(telescope.load_extension, "zf-native")
  pcall(telescope.load_extension, "ui-select")
  return true
end)

-- Commands
lz:cmds({ "Telescope" })

-- Keymaps
lz:key(
  "n",
  "<leader>b",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Open Buffer Picker" }
)
lz:key("n", "<leader>f", "<cmd>Telescope find_files<CR>", { desc = "Open File Picker" })
lz:key(
  "n",
  "<leader>F",
  "<cmd>Telescope find_files no_ignore=true<CR>",
  { desc = "Open File Picker (All)" }
)
lz:key(
  "n",
  "<leader>d",
  "<cmd>Telescope diagnostics<CR>",
  { desc = "Open Diagnostics Picker" }
)
lz:key("n", "<leader>q", "<cmd>Telescope quickfix<CR>", { desc = "Open Quickfix Picker" })
lz:key(
  "n",
  "<leader>s",
  "<cmd>Telescope lsp_document_symbols<CR>",
  { desc = "Open Symbol Picker (Document)" }
)
lz:key(
  "n",
  "<leader>S",
  "<cmd>Telescope lsp_workspace_symbols<CR>",
  { desc = "Open Symbol Picker (Workspace)" }
)
lz:key(
  "n",
  "<leader>;",
  "<cmd>Telescope command_history<CR>",
  { desc = "Open Command History Picker" }
)
lz:key("n", "<leader>:", "<cmd>Telescope commands<CR>", { desc = "Open Commands Picker" })
lz:key("n", "<leader>'", "<cmd>Telescope marks<CR>", { desc = "Open Marks Picker" })
lz:key(
  "n",
  '<leader>"',
  "<cmd>Telescope registers<CR>",
  { desc = "Open Registers Picker" }
)
lz:key(
  "n",
  "<leader><CR>",
  "<cmd>Telescope builtin<CR>",
  { desc = "Open Picker Command Palette" }
)
lz:key(
  "n",
  "<leader>,",
  "<cmd>Telescope oldfiles cwd_only=true<CR>",
  { desc = "Open Recents Picker (cwd)" }
)
lz:key("n", "<leader><", "<cmd>Telescope oldfiles<CR>", { desc = "Open Recents Picker" })
lz:key("n", "<leader>.", "<cmd>Telescope resume<CR>", { desc = "Picker Resume" })
lz:key("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Global Search" })
lz:key("n", "<leader>?", "<cmd>Telescope help_tags<CR>", { desc = "Open Help Picker" })

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end
lz:key("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Branches" })
lz:key(
  "n",
  "<leader>gc",
  "<cmd>Telescope git_bcommits<CR>",
  { desc = "Commits (buf)" }
)
lz:key(
  "n",
  "<leader>gC",
  "<cmd>Telescope git_commits<CR>",
  { desc = "Commits (repo)" }
)
lz:key("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Files" })
lz:key("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
lz:key("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Stash" })

local old_ui_select = vim.ui["select"]
---@diagnostic disable-next-line: duplicate-set-field
vim.ui["select"] = function(...)
  vim.ui["select"] = old_ui_select
  lz:load()
  vim.ui["select"](...)
end
