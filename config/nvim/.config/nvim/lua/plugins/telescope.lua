--- Return a function that executes a telescope builtin command lazy-loading it
--first if it is not loaded
---@param cmd string builtin command to run
---@vararg any? arguments to pass to the command
---@return fun()
local tcmd = function(cmd, ...)
  local args = { ... }
  return function()
    require("telescope.builtin")[cmd](unpack(args))
  end
end

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
      { "<leader><space>", tcmd("find_files"), desc = "Find File" },
      { "<leader>;", tcmd("buffers"), desc = "Find Buffer" },
      { "<leader>:", tcmd("command_history"), desc = "Find Cmd History" },
      { "<leader>,", tcmd("oldfiles"), desc = "Find Recent File" },
      { "<leader>.", tcmd("resume"), desc = "Find Resume" },
      { "<leader>/", tcmd("live_grep"), desc = "Grep" },
      { "<leader>?", tcmd("builtin"), desc = "Find Picker Cmd" },
      -- Find
      { "<leader>f'", tcmd("marks"), desc = "Marks" },
      { '<leader>f"', tcmd("registers"), desc = "Registers" },
      { "<leader>fc", tcmd("commands"), desc = "Commands" },
      { "<leader>ff", tcmd("find_files", { no_ignore = true }), desc = "Files All" },
      { "<leader>fh", tcmd("help_tags"), desc = "Help" },
      { "<leader>fk", tcmd("keymaps"), desc = "Keymaps" },
      { "<leader>fm", tcmd("man_pages"), desc = "Man Pages" },
      { "<leader>fr", tcmd("oldfiles", { only_cwd = true }), desc = "Recent File (cwd)" },
      { "<leader>fz", tcmd("spell_suggest"), desc = "Spell" },
      -- Git
      { "<leader>gb", tcmd("git_branches"), desc = "Branches" },
      { "<leader>gc", tcmd("git_bcommits"), desc = "Commits (buf)" },
      { "<leader>gC", tcmd("git_commits"), desc = "Commits (repo)" },
      { "<leader>gf", tcmd("git_files"), desc = "Files" },
      { "<leader>gs", tcmd("git_status"), desc = "Status" },
      { "<leader>gw", tcmd("git_stash"), desc = "Stash" },
    }
  end,
  init = function()
    -- Lsp additions
    local lsp = require("utils.lsp")
    lsp.register_attach_handler(function(client, bufnr)
      local symbols = {
        "Class",
        "Function",
        "Method",
        "Constructor",
        "Interface",
        "Module",
        "Struct",
        "Trait",
        "Field",
        "Property",
      }
      lsp.register_keys(client, bufnr, {
        {
          "<leader>cD",
          tcmd("diagnostics", { bufnr = 0 }),
          desc = "Doc Diagnostics (lsp)",
        },
        {
          "<leader>cs",
          tcmd("lsp_document_symbols", { symbols = symbols }),
          desc = "Document Symbols (lsp)",
          has = "documentSymbol",
        },
        {
          "<leader>cS",
          tcmd("lsp_dynamic_workspace_symbols", { symbols = symbols }),
          desc = "Workspace Symbols (lsp)",
          has = "workspaceSymbol",
        },
        { "gd", tcmd("lsp_definitions"), desc = "Goto Def (lsp)", has = "definition" },
        {
          "gi",
          tcmd("lsp_implementations"),
          desc = "Goto Impl (lsp)",
          has = "implementation",
        },
        { "gr", tcmd("lsp_references"), desc = "Goto Ref (lsp)", has = "references" },
        {
          "gz",
          tcmd("lsp_type_definitions"),
          desc = "Goto Type (lsp)",
          has = "typeDefinition",
        },
      })
    end)
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
          n = { q = actions.close },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          -- don't include the filename in the search results
          only_sort_text = true,
        },
        buffers = {
          initial_mode = "normal",
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
