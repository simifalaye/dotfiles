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
      { "<C-b>", "<cmd>Telescope buffers<CR>", desc = "Find Buffer" },
      { "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Find Text" },
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>.", "<cmd>Telescope resume<CR>", desc = "Find Resume" },
      { "<leader>,", "<cmd>Telescope builtin<CR>", desc = "Find Builtin" },
      { "<leader>'", "<cmd>Telescope oldfiles<CR>", desc = "Find Recent" },
      { "<leader>;", "<cmd>Telescope help_tags<CR>", desc = "Find Help" },
      {
        "<leader>:",
        "<cmd>Telescope command_history<CR>",
        desc = "Find Hist (cmd)",
      },
      {
        "<leader>/",
        "<cmd>Telescope search_history<CR>",
        desc = "Find Hist (search)",
      },
      { "<leader>f'", "<cmd>Telescope marks<CR>", desc = "Marks" },
      { '<leader>f"', "<cmd>Telescope registers<CR>", desc = "Registers" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      {
        "<leader>ff",
        "<cmd>Telescope find_files no_ignore=true<CR>",
        desc = "Files (All)",
      },
      { "<leader>fg", "<cmd>Telescope grep_string<CR>", desc = "Grep Word" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
      -- Git
      { "<leader>fgb", "<cmd>Telescope git_branches<CR>", desc = "Branches" },
      { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>fgC", "<cmd>Telescope git_bcommits<CR>", desc = "BCommits" },
      { "<leader>fgf", "<cmd>Telescope git_files<CR>", desc = "Files" },
      { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- Lsp
      { "<leader>fld", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      {
        "<leader>fls",
        "<cmd>Telescope lsp_document_symbols<CR>",
        desc = "Symbols",
      },
    }
  end,
  init = function()
    local m = require("utils.map")
    m.group("<leader>f", "+find")
    m.group("<leader>fg", "+git")
    m.group("<leader>fl", "+lsp")
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
          initial_mode = "normal",
          sort_mru = true,
          ignore_current_buffer = true,
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
