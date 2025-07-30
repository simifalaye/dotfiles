local find_files
find_files = function(opts, no_ignore)
  opts = opts or {}
  no_ignore = vim.F.if_nil(no_ignore, false)
  opts.attach_mappings = function(_, map)
    map({ "n", "i" }, "<C-h>", function(prompt_bufnr) -- <C-h> to toggle modes
      local prompt = require("telescope.actions.state").get_current_line()
      require("telescope.actions").close(prompt_bufnr)
      no_ignore = not no_ignore
      find_files({ default_text = prompt }, no_ignore)
    end)
    return true
  end

  if no_ignore then
    opts.no_ignore = true
    opts.hidden = true
    opts.prompt_title = "Find Files <ALL>"
    require("telescope.builtin").find_files(opts)
  else
    opts.prompt_title = "Find Files"
    require("telescope.builtin").find_files(opts)
  end
end

local M = {
  "nvim-telescope/telescope.nvim",
  enabled = false,
  version = false,
}

M.dependencies = {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make")
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
}

M.cmd = { "Telescope" }

M.keys = {
  -- Root
  {
    "<leader>;",
    "<cmd>Telescope command_history<CR>",
    desc = "Open Command History Picker",
  },
  {
    "<leader>:",
    "<cmd>Telescope commands<CR>",
    desc = "Open Commands Picker",
  },
  {
    "<leader>'",
    "<cmd>Telescope marks<CR>",
    desc = "Open Marks Picker",
  },
  {
    '<leader>"',
    "<cmd>Telescope registers<CR>",
    desc = "Open Registers Picker",
  },
  { "<leader><CR>", "<cmd>Telescope resume<CR>", desc = "Resume Picker" },
  {
    "<leader>,",
    "<cmd>Telescope buffers sort_mru=true<CR>",
    desc = "Open Buffers Picker",
  },
  {
    "<leader>.",
    find_files,
    desc = "Open Files Picker",
  },
  {
    "<leader>/",
    "<cmd>Telescope live_grep<CR>",
    desc = "Open Live Grep Picker",
  },
  { "<leader>?", "<cmd>Telescope help_tags<CR>", desc = "Open Help Picker" },
  -- Find
  {
    "<leader>f;",
    "<cmd>Telescope command_history<CR>",
    desc = "Command History",
  },
  {
    "<leader>f:",
    "<cmd>Telescope commands<CR>",
    desc = "Commands",
  },
  {
    "<leader>f'",
    "<cmd>Telescope marks<CR>",
    desc = "Marks",
  },
  {
    '<leader>f"',
    "<cmd>Telescope registers<CR>",
    desc = "Registers",
  },
  {
    "<leader>f<CR>",
    "<cmd>Telescope<CR>",
    desc = "Open Picker",
  },
  { "<leader>f.", "<cmd>Telescope resume<CR>", desc = "Resume" },
  { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer lines" },
  { "<leader>fa", "<cmd>Telescope autocommands<CR>", desc = "Autocommands" },
  {
    "<leader>fb",
    "<cmd>Telescope buffers sort_mru=true<CR>",
    desc = "Buffers",
  },
  {
    "<leader>fd",
    "<cmd>Telescope diagnostics<CR>",
    desc = "Diagnostics",
  },
  {
    "<leader>ff",
    find_files,
    desc = "Files",
  },
  {
    "<leader>fF",
    "<cmd>Telescope git_files<CR>",
    desc = "Files",
  },
  {
    "<leader>fg",
    "<cmd>Telescope grep_string<CR>",
    desc = "Grep",
  },
  { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
  { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
  { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Man pages" },
  { "<leader>fo", "<cmd>Telescope vim_options<CR>", desc = "Options" },
  {
    "<leader>fr",
    "<cmd>Telescope oldfiles cwd_only=true<CR>",
    desc = "Recents (cwd)",
  },
  {
    "<leader>fR",
    "<cmd>Telescope oldfiles<CR>",
    desc = "Recents",
  },
  {
    "<leader>fs",
    "<cmd>Telescope lsp_document_symbols<CR>",
    desc = "Lsp Symbols",
  },
  {
    "<leader>fq",
    "<cmd>Telescope quickfix<CR>",
    desc = "Quickfix",
  },
}

M.config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local themes = require("telescope.themes")
  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      layout_strategy = "bottom_pane",
      -- layout_strategy = "flex",
      -- layout_config = {
      --   horizontal = { prompt_position = "top", preview_width = 0.55 },
      --   vertical = { prompt_position = "top", mirror = false },
      --   flex = { prompt_position = "top", flip_columns = 150 },
      --   width = 0.87,
      --   height = 0.80,
      -- },
      sorting_strategy = "ascending",
      preview = {
        treesitter = {
          enable = true,
          disable = {
            "html", -- TODO: Check if still broken
          },
        },
      },
      mappings = {
        i = {
          ["<Up>"] = actions.cycle_history_prev,
          ["<Down>"] = actions.cycle_history_next,
          ["<C-q>"] = function(...)
            actions.smart_send_to_qflist(...)
            actions.open_qflist(...)
          end,
        },
        n = {
          ["<C-c>"] = actions.close,
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
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      ["ui-select"] = {
        themes.get_dropdown(),
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      buffers = {
        mappings = {
          i = {
            ["<C-x>"] = actions.delete_buffer,
          },
        },
      },
    },
  })

  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "ui-select")
end

-- return M

return {
  M,
}
