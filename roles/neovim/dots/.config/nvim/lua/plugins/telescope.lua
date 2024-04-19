local reqcall = require("utils.lib").reqcall

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1,
      build = "make",
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
  },
  cmd = "Telescope",
  keys = {
    {
      "<leader><leader>",
      "<cmd>Telescope buffers sort_mru=true<CR>",
      desc = "Show Buffers",
    },
    -- Leader + f
    { "<leader>f;", "<cmd>Telescope commands<CR>", desc = "Commands" },
    { "<leader>f:", "<cmd>Telescope command_history<CR>", desc = "Command History" },
    { "<leader>f'", "<cmd>Telescope marks<CR>", desc = "Marks" },
    { '<leader>f"', "<cmd>Telescope registers<CR>", desc = "Registers" },
    { "<leader>f.", "<cmd>Telescope resume<CR>", desc = "Resume" },
    { "<leader>f/", "<cmd>Telescope search_history<CR>", desc = "Search History" },
    { "<leader>f?", "<cmd>Telescope builtin<CR>", desc = "Builtin" },
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true<CR>",
      desc = "Buffers",
    },
    {
      "<leader>fB",
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      desc = "Current Buffer",
    },
    {
      "<leader>fc",
      "<cmd>Telescope colorscheme<CR>",
      desc = "Colorscheme",
    },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Files" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep Live" },
    { "<leader>fG", "<cmd>Telescope grep_string<CR>", desc = "Grep String" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
    { "<leader>fH", "<cmd>Telescope highlights<CR>", desc = "Highlights" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Manpages" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
    { "<leader>fs", "<cmd>Telescope spell_suggest<CR>", desc = "Spell" },
    { "<leader>fS", "<cmd>Telescope symbols<CR>", desc = "Symbols" },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Oldfiles" },
    { "<leader>fO", "<cmd>Telescope vim_options<CR>", desc = "Options" },
  },
  init = function()
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register({ ["<leader>f"] = { name = "+find" } })
    end

    local old_ui_select = vim.ui["select"]
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui["select"] = function(...)
      vim.ui["select"] = old_ui_select
      require("lazy").load({ plugins = { "telescope.nvim" } })
      vim.ui["select"](...)
    end
  end,
  config = function()
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
  end,
}
