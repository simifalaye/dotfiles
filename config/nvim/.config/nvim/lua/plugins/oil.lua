return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "File Explorer",
      },
    },
    init = function()
      require("utils.command").augroup("user_oil_start", {
        {
          desc = "Start oil when no commands are provided",
          event = "VimEnter",
          pattern = "*",
          command = function()
            local should_skip = false
            if
                vim.fn.argc() > 0
                or vim.fn.line2byte(vim.fn.line("$")) ~= -1
                or not vim.o.modifiable
            then
              should_skip = true
            else
              for _, arg in pairs(vim.v.argv) do
                if
                    arg == "-b"
                    or arg == "-c"
                    or vim.startswith(arg, "+")
                    or arg == "-S"
                then
                  should_skip = true
                  break
                end
              end
            end
            if not should_skip then
              require("oil").open()
              -- Must re-trigger bufread since plugin is lazy-loaded after the
              -- new empty buffer has already be read by nvim
              vim.cmd("doautocmd BufReadCmd")
            end
          end,
        },
        {
          desc = "Start neo-tree when a directory is given",
          event = "VimEnter",
          pattern = "*",
          command = function()
            if
                vim.fn.argc() == 1
                and vim.fn.isdirectory(vim.fn.argv()[1]) == 1
                and vim.fn.exists("s:std_in") ~= 1
            then
              require("oil").open()
              vim.cmd("doautocmd BufReadCmd")
            end
          end,
        },
      })
    end,
    opts = {
      skip_confirm_for_simple_edits = true,
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["g."] = "actions.toggle_hidden",
        ["q"] = "actions.close",
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["R"] = "actions.refresh",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
      },
      -- delete_to_trash = true,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

}
