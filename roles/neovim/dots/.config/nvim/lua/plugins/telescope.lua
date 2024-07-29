local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>f", group = "+find" } })
  wk.add({ { "<leader>fg", group = "+git" } })
end

local lz = require("utils.lazy").new("telescope", function()
  local telescope = require("telescope")
  local actions = require("telescope.actions") ---@module 'telescope.actions'
  local themes = require("telescope.themes") ---@module 'telescope.themes'
  local git_layout_config = {
    initial_mode = "normal",
    layout_strategy = "vertical",
    layout_config = {
      preview_cutoff = 0,
      height = 0.99,
      width = 0.99,
    },
  }
  -- Setup plugin
  telescope.setup({
    defaults = vim.tbl_deep_extend("force", themes.get_ivy(), {
      path_display = { "truncate" },
      mappings = {
        i = {
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-s>"] = actions.select_horizontal,
          ["<c-x>"] = false,
        },
        n = {
          ["<C-c>"] = actions.close,
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-s>"] = actions.select_horizontal,
          ["<c-x>"] = false,
        },
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
          n = {
            ["<c-x>"] = actions.delete_buffer,
          },
        },
      },
      git_branches = git_layout_config,
      git_bcommits = git_layout_config,
      git_commits = git_layout_config,
      git_status = git_layout_config,
      git_stash = git_layout_config,
    },
  })
  -- Enable Telescope extensions if they are installed
  pcall(telescope.load_extension, "zf-native")
  pcall(telescope.load_extension, "ui-select")
  return true
end)
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
lz:key("n", "<leader>fgb", "<cmd>Telescope git_branches<CR>", { desc = "Branches" })
lz:key("n", "<leader>fgc", "<cmd>Telescope git_bcommits<CR>", { desc = "Commits (buf)" })
lz:key("n", "<leader>fgC", "<cmd>Telescope git_commits<CR>", { desc = "Commits" })
lz:key("n", "<leader>fgf", "<cmd>Telescope git_files<CR>", { desc = "Files" })
lz:key("n", "<leader>fgs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
lz:key("n", "<leader>fgS", "<cmd>Telescope git_stash<CR>", { desc = "Stash" })
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
lz:key("n", "<leader>ft", "<cmd>Telescope live_grep<CR>", { desc = "Text (live)" })
lz:key("n", "<leader>fT", "<cmd>Telescope grep_string<CR>", { desc = "Text" })
lz:key("n", "<leader>fo", "<cmd>Telescope vim_options<CR>", { desc = "Options" })

local old_ui_select = vim.ui["select"]
---@diagnostic disable-next-line: duplicate-set-field
vim.ui["select"] = function(...)
  vim.ui["select"] = old_ui_select
  lz:load()
  vim.ui["select"](...)
end
