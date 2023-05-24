return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1,
      build = "make",
    },
  },
  cmd = "Telescope",
  keys = function()
    return {
      -- Leader
      { "<leader>,", "<cmd>Telescope builtin<CR>", desc = "Picker Builtin" },
      { "<leader>.", "<cmd>Telescope resume<CR>", desc = "Resume picker" },
      { "<leader>:", "<cmd>Telescope command_history<CR>", desc = "Cmd Hist", },
      { "<leader>;", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
      { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Global Search" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Files" },
      { "<leader>F", "<cmd>Telescope git_files<CR>", desc = "Git Files" },
      -- Search
      { "<leader>s'", "<cmd>Telescope marks<CR>", desc = "Marks" },
      { '<leader>s"', "<cmd>Telescope registers<CR>", desc = "Registers" },
      { "<leader>sc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics (LSP)" },
      {
        "<leader>sf",
        "<cmd>Telescope find_files no_ignore=true<CR>",
        desc = "Files (All)",
      },
      { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
      { "<leader>sr", "<cmd>Telescope oldfiles only_cwd=true<CR>", desc = "Recent" },
      {
        "<leader>ss",
        "<cmd>Telescope lsp_document_symbols<CR>",
        desc = "Symbols (LSP)",
      },
      { "<leader>sz", "<cmd>Telescope spell_suggest<CR>", desc = "Spell" },
    }
  end,
  init = function()
    local m = require("utils.map")
    m.group("<leader>s", "+search")
  end,
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        initial_mode = "insert",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
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
            ["<Esc>"] = actions.close,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          sort_mru = true,
          previewer = false,
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        git_files = {
          hidden = true,
          show_untracked = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },
      extenstions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    })
    -- Highlights
    local c = require("utils.color")
    c.set_highlights({
      TelescopeBorder = { fg = c.get_hl_group("Normal", "fg") },
      TelescopePromptBorder = { fg = c.get_hl_group("Normal", "fg") },
      TelescopePromptNormal = c.get_hl_group("Normal"),
      TelescopePromptPrefix = { fg = c.get_hl_group("Title", "fg") },
      TelescopeNormal = c.get_hl_group("Normal"),
      TelescopePreviewTitle = { fg = c.get_hl_group("Conditional", "fg") },
      TelescopePromptTitle = { fg = c.get_hl_group("Title", "fg") },
      TelescopeResultsTitle = { fg = c.get_hl_group("Label", "fg") },
      TelescopeSelection = { bg = c.get_hl_group("SpecialKey", "fg") },
      TelescopeResultsDiffAdd = {
        fg = "NONE",
        bg = c.get_hl_group("ModeMsg", "fg"),
      },
      TelescopeResultsDiffChange = {
        fg = "NONE",
        bg = c.get_hl_group("Label", "fg"),
      },
      TelescopeResultsDiffDelete = {
        fg = "NONE",
        bg = c.get_hl_group("ErrorMsg", "fg"),
      },
    })
  end,
}
