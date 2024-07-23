local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>f", group = "+find" } })
end

local lz = require("utils.lazy").new("nvim-telescope", function()
  local telescope = require("telescope")
  local actions = require("telescope.actions") ---@module 'telescope.actions'
  local themes = require("telescope.themes") ---@module 'telescope.themes'
  -- Setup plugin
  telescope.setup({
    defaults = vim.tbl_deep_extend("force", themes.get_ivy(), {
      path_display = { "truncate" },
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
    }),
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
  pcall(telescope.load_extension, "zf-native")
  pcall(telescope.load_extension, "ui-select")
  return true
end, { "telescope" })
lz:cmds({ "Telescope" })

-- Keymaps
lz:key(
  "n",
  "<leader><leader>",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Show Buffers" }
)
lz:key("n", "<leader>f;", "<cmd>Telescope commands<CR>", { desc = "Commands" })
lz:key(
  "n",
  "<leader>f:",
  "<cmd>Telescope command_history<CR>",
  { desc = "Command History" }
)
lz:key("n", "<leader>f'", "<cmd>Telescope marks<CR>", { desc = "Marks" })
lz:key("n", '<leader>f"', "<cmd>Telescope registers<CR>", { desc = "Registers" })
lz:key("n", "<leader>f.", "<cmd>Telescope resume<CR>", { desc = "Resume" })
lz:key(
  "n",
  "<leader>f/",
  "<cmd>Telescope search_history<CR>",
  { desc = "Search History" }
)
lz:key("n", "<leader>f?", "<cmd>Telescope builtin<CR>", { desc = "Builtin" })
lz:key(
  "n",
  "<leader>fb",
  "<cmd>Telescope buffers sort_mru=true<CR>",
  { desc = "Buffers" }
)
lz:key(
  "n",
  "<leader>fB",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "Current Buffer" }
)
lz:key("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Colorscheme" })
lz:key("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Files" })
lz:key("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
lz:key("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep Live" })
lz:key("n", "<leader>fG", "<cmd>Telescope grep_string<CR>", { desc = "Grep String" })
lz:key("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })
lz:key("n", "<leader>fH", "<cmd>Telescope highlights<CR>", { desc = "Highlights" })
lz:key("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
lz:key("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Manpages" })
lz:key("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Quickfix" })
lz:key(
  "n",
  "<leader>fr",
  "<cmd>Telescope oldfiles cwd_only=true<CR>",
  { desc = "Recent (cwd)" }
)
lz:key("n", "<leader>fR", "<cmd>Telescope oldfiles<CR>", { desc = "Recent" })
lz:key("n", "<leader>fs", "<cmd>Telescope spell_suggest<CR>", { desc = "Spell" })
lz:key("n", "<leader>fS", "<cmd>Telescope symbols<CR>", { desc = "Symbols" })
lz:key("n", "<leader>fo", "<cmd>Telescope vim_options<CR>", { desc = "Options" })

local old_ui_select = vim.ui["select"]
---@diagnostic disable-next-line: duplicate-set-field
vim.ui["select"] = function(...)
  vim.ui["select"] = old_ui_select
  lz:load()
  vim.ui["select"](...)
end
