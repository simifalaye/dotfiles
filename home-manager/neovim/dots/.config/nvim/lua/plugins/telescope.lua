local actions = reqcall("telescope.actions") ---@module 'telescope.actions'
local themes = reqcall("telescope.themes") ---@module 'telescope.themes'

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

vim.keymap.set("n", "<leader>t", find_files)

return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    cmd = "Telescope",
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({ { "<leader>g", group = "+git" } })
      end
    end,
    keys = {
      {
        "<leader><CR>",
        "<cmd>Telescope<CR>",
        desc = "Open Picker",
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
        "<leader>,",
        "<cmd>Telescope oldfiles cwd_only=true<CR>",
        desc = "Open Recents Picker (cwd)",
      },
      {
        "<leader><",
        "<cmd>Telescope oldfiles<CR>",
        desc = "Open Recents Picker",
      },
      { "<leader>.", "<cmd>Telescope resume<CR>", desc = "Resume Picker" },
      {
        "<leader>/",
        "<cmd>Telescope live_grep<CR>",
        desc = "Open Live Grep Picker",
      },
      { "<leader>?", "<cmd>Telescope help_tags<CR>", desc = "Open Help Picker" },
      {
        "<leader>b",
        "<cmd>Telescope buffers sort_mru=true<CR>",
        desc = "Open Buffers Picker",
      },
      {
        "<leader>d",
        "<cmd>Telescope diagnostics<CR>",
        desc = "Open Diagnostics Picker",
      },
      {
        "<leader>f",
        find_files,
        desc = "Open Files Picker",
      },
      {
        "<leader>gc",
        "<cmd>Telescope git_bcommits<CR>",
        desc = "Open Buf Commits Picker",
      },
      {
        "<leader>gC",
        "<cmd>Telescope git_commits<CR>",
        desc = "Open Commits Picker",
      },
      {
        "<leader>gf",
        "<cmd>Telescope git_files<CR>",
        desc = "Open Files Picker",
      },
      {
        "<leader>s",
        "<cmd>Telescope lsp_document_symbols<CR>",
        desc = "Open Lsp Symbols Picker",
      },
      {
        "<leader>q",
        "<cmd>Telescope quickfix<CR>",
        desc = "Open Quickfix Picker",
      },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        layout_strategy = "flex",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { prompt_position = "top", mirror = false },
          flex = { prompt_position = "top", flip_columns = 150 },
          width = 0.87,
          height = 0.80,
        },
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
            ["<M-q>"] = false,
            ["<M-f>"] = false,
            ["<M-k>"] = false,
            ["<Esc>"] = actions.close,
            ["<C-c>"] = actions.close,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-q>"] = function(...)
              actions.smart_send_to_qflist(...)
              actions.open_qflist(...)
            end,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
            ["<CR>"] = actions.select_default,
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
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
