local reqcall = require("utils.reqcall")
local actions = reqcall("telescope.actions") ---@module 'telescope.actions'

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1,
      build = "make",
    },
  },
  cmd = "Telescope",
  keys = {
    -- Leader
    { "<leader>;", "<cmd>Telescope find_files<CR>", desc = "File Picker" },
    { "<leader>:", "<cmd>Telescope commands<CR>", desc = "Commands Picker" },
    { "<leader>'", "<cmd>Telescope marks<CR>", desc = "Marks Picker" },
    { '<leader>"', "<cmd>Telescope registers<CR>", desc = "Registers Picker" },
    { "<leader><CR>", "<cmd>Telescope resume<CR>", desc = "Resume Picker" },
    { "<leader>,", "<cmd>Telescope buffers sort_mru=true<CR>", desc = "Buffer Picker" },
    { "<leader>.", "<cmd>Telescope oldfiles<CR>", desc = "Oldfiles Picker" },
    { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Grep Picker" },
    { "<leader>?", "<cmd>Telescope builtin<CR>", desc = "Picker Help" },
    -- Leader + f
    { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "In buffer" },
    { "<leader>fc", "<cmd>Telescope command_history<CR>", desc = "Command history" },
    { "<leader>fC", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
    {
      "<leader>ff",
      "<cmd>Telescope find_files no_ignore=true no_ignore_parent=true hidden=true<CR>",
      desc = "Files (all)",
    },
    { "<leader>fF", "<cmd>Telescope oldfiles<CR>", desc = "Oldfiles" },
    { "<leader>fg", "<cmd>Telescope grep_string<CR>", desc = "Grep string" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
    { "<leader>fH", "<cmd>Telescope highlights<CR>", desc = "Highlights" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Manpages" },
    { "<leader>fo", "<cmd>Telescope vim_options<CR>", desc = "Options" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
    { "<leader>fs", "<cmd>Telescope spell_suggest<CR>", desc = "Spell" },
  },
  init = function()
    require("utils.map").group("<leader>f", "+find")
  end,
  opts = {
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
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<ESC>"] = actions.close,
          ["<C-c>"] = false,
        },
        n = { ["q"] = actions.close },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
