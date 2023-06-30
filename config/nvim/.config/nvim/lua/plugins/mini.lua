local augroup = require("utils.command").augroup

return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local indentscope = require("mini.indentscope")
      indentscope.setup({
        draw = {
          delay = 0,
          animation = indentscope.gen_animation.none(),
        },
        -- Which character to use for drawing scope indicator
        -- alternative styles: ┆ ┊ ╎
        symbol = "│",
        options = { try_as_border = true },
      })
      -- Disable for certain filetypes
      augroup("MiniIndentscopeDisable", {
        {
          desc = "Highlight window when focused",
          event = "FileType",
          pattern = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
          command = function()
            vim.b.miniindentscope_disable = true
          end,
        },
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    keys = {
      { "sa", desc = "Surround add", mode = { "n", "x" } },
      { "sd", desc = "Surround delete" },
      { "sr", desc = "Surround replace" },
      { "sf", desc = "Surround find" },
      { "sF", desc = "Surround find left" },
      { "sh", desc = "Surround highlight" },
    },
    opts = {
      mappings = {
        update_n_lines = "",
      },
      -- Number of lines within which surrounding is searched
      n_lines = 62,
      -- How to search for surrounding (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
      search_method = "cover_or_next",
    },
  },
  {
    "echasnovski/mini.bracketed",
    version = "*",
    event = "BufRead",
    config = true,
  },
  {
    "echasnovski/mini.bufremove",
    version = "*",
    event = "BufRead",
    keys = {
      {
        "<leader>x",
        "<cmd>lua MiniBufremove.delete()<CR>",
        desc = "Delete Buffer",
      },
      {
        "<leader>X",
        "<cmd>lua MiniBufremove.wipeout()<CR>",
        desc = "Wipe Buffer",
      },
    },
    config = true,
  },
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "-",
        function()
          require("mini.files").open()
        end,
        desc = "Open file browser",
      },
      {
        "_",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Open file browser (file)",
      },
    },
    init = function()
      -- Setup autocommands
      augroup("user_mini_files", {
        {
          desc = "Start mini.files when a directory is given",
          event = "VimEnter",
          pattern = "*",
          command = function()
            if
              vim.fn.argc() == 1
              and vim.fn.isdirectory(vim.fn.argv()[1]) == 1
              and vim.fn.exists("s:std_in") ~= 1
            then
              require("mini.files").open()
            end
          end,
        },
      })
    end,
    opts = {
      options = {
        -- Manual autocmd setup since netrw is disabled completely (in lazy.nvim)
        use_as_default_explorer = false,
      },
    },
    config = function(_, opts)
      -- Setup show dotfiles toggle
      local show_dotfiles = true
      local filter_show = function(_)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end
      augroup("user_mini_files", {
        {
          desc = "Toggle hiding/revealing dotfiles",
          event = "User",
          pattern = "MiniFilesBufferCreate",
          command = function(args)
            local buf_id = args.data.buf_id
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
          end,
        },
      })
      opts.content = {
        filter = function(fs_entry)
          if show_dotfiles then
            return filter_show()
          else
            return filter_hide(fs_entry)
          end
        end,
      }

      -- Setup plugin
      require("mini.files").setup(opts)
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter(
            { a = "@function.outer", i = "@function.inner" },
            {}
          ),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = true,
  },
}
