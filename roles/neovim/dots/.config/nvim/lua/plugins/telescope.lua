local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.register({ ["<leader>f"] = { name = "+find" } })
end

local old_ui_select = vim.ui["select"]
---@diagnostic disable-next-line: duplicate-set-field
vim.ui["select"] = function(...)
  vim.ui["select"] = old_ui_select
  -- require("lazy").load({ plugins = { "telescope.nvim" } })
  vim.ui["select"](...)
end

local telescope = require("telescope")
local actions = require("telescope.actions") ---@module 'telescope.actions'
local themes = require("telescope.themes") ---@module 'telescope.themes'
-- Setup plugin
telescope.setup({
  defaults = {
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.50,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
        ["<C-c>"] = false,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-s>"] = actions.select_horizontal,
      },
      n = { ["q"] = actions.close },
    },
  },
  extensions = {
    ["ui-select"] = {
      themes.get_dropdown(),
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-x>"] = actions.delete_buffer,
        },
      },
    },
  },
})
-- Enable Telescope extensions if they are installed
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

-- Keymaps
vim.keymap.set(
  "n",
  "<leader><leader>",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Show Buffers" }
)
vim.keymap.set("n", "<leader>f;", "<cmd>Telescope commands<CR>", { desc = "Commands" })
vim.keymap.set(
  "n",
  "<leader>f:",
  "<cmd>Telescope command_history<CR>",
  { desc = "Command History" }
)
vim.keymap.set("n", "<leader>f'", "<cmd>Telescope marks<CR>", { desc = "Marks" })
vim.keymap.set("n", '<leader>f"', "<cmd>Telescope registers<CR>", { desc = "Registers" })
vim.keymap.set("n", "<leader>f.", "<cmd>Telescope resume<CR>", { desc = "Resume" })
vim.keymap.set(
  "n",
  "<leader>f/",
  "<cmd>Telescope search_history<CR>",
  { desc = "Search History" }
)
vim.keymap.set("n", "<leader>f?", "<cmd>Telescope builtin<CR>", { desc = "Builtin" })
vim.keymap.set(
  "n",
  "<leader>fb",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Buffers" }
)
vim.keymap.set(
  "n",
  "<leader>fB",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "Current Buffer" }
)
vim.keymap.set(
  "n",
  "<leader>fc",
  "<cmd>Telescope colorscheme<CR>",
  { desc = "Colorscheme" }
)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Files" })
vim.keymap.set(
  "n",
  "<leader>fd",
  "<cmd>Telescope diagnostics<CR>",
  { desc = "Diagnostics" }
)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep Live" })
vim.keymap.set(
  "n",
  "<leader>fG",
  "<cmd>Telescope grep_string<CR>",
  { desc = "Grep String" }
)
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })
vim.keymap.set(
  "n",
  "<leader>fH",
  "<cmd>Telescope highlights<CR>",
  { desc = "Highlights" }
)
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Manpages" })
vim.keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Quickfix" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<CR>", { desc = "Spell" })
vim.keymap.set("n", "<leader>fS", "<cmd>Telescope symbols<CR>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Oldfiles" })
vim.keymap.set("n", "<leader>fO", "<cmd>Telescope vim_options<CR>", { desc = "Options" })
