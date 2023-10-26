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
            "fzf",
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
    init = function()
      local utils = require("utils.map")
      utils.group("s", "+surround", { "n", "x" })
    end,
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
        desc = "E[x]it Buf",
      },
      {
        "<leader>X",
        "<cmd>lua MiniBufremove.delete(0, true)<CR>",
        desc = "E[x]it Buf!",
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
            local arg = vim.fn.argv()[1]
            if
              vim.fn.argc() == 1
              and vim.fn.isdirectory(arg) == 1
              and vim.fn.exists("s:std_in") ~= 1
            then
              require("mini.files").open(arg)
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
        {
          desc = "Close mini.files on lost focus",
          event = "BufEnter",
          pattern = "*",
          command = function(_)
            local ft = vim.bo.filetype
            if ft == "minifiles" or ft == "minifiles-help" then
              return
            end
            local cur_win_id = vim.api.nvim_get_current_win()
            require("mini.files").close()
            pcall(vim.api.nvim_set_current_win, cur_win_id)
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
    opts = function()
      local prequire = require("utils.prequire")
      local ai = require("mini.ai")
      local opts = {
        n_lines = 500,
        mappings = {
          around_last = "",
          inside_last = "",
          around_next = "",
          inside_next = "",
        },
      }
      if prequire("nvim-treesitter-textobjects") ~= nil then
        opts.custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter(
            { a = "@function.outer", i = "@function.inner" },
            {}
          ),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        }
      end
      return opts
    end,
    config = true,
  },
  {
    "echasnovski/mini.align",
    version = "*",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align Text" },
      { "gA", mode = { "n", "x" }, desc = "Align Text (Preview)" },
    },
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "echasnovski/mini.pick",
    version = false,
    cmd = "Pick",
    keys = {
      { "<leader>f", "<cmd>Pick files<CR>", desc = "File Picker" },
      {
        "<leader>b",
        function()
          local buffers_output = vim.api.nvim_exec("ls t", true)
          local cur_buf_id = vim.api.nvim_get_current_buf()
          local items = {}
          local curr_item = {}
          for _, l in ipairs(vim.split(buffers_output, "\n")) do
            local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
            local buf_id = tonumber(buf_str)
            local item = { text = name, bufnr = buf_id }
            if buf_id ~= cur_buf_id then
              table.insert(items, item)
            else
              curr_item = item
            end
          end
          table.insert(items, curr_item)
          local minipick = require("mini.pick")
          local show = minipick.config.source.show
            or function(buf_id, items_, query)
              minipick.default_show(buf_id, items_, query, { show_icons = true })
            end
          local opts = { source = { name = "Buffers", show = show, items = items } }
          return minipick.start(opts)
        end,
        desc = "Buffer Picker",
      },
      { "<leader>.", "<cmd>Pick resume<CR>", desc = "Resume Picker" },
      { "<leader>/", "<cmd>Pick grep_live<CR>", desc = "Grep Picker" },
      { "<leader>,", "<cmd>Pick help<CR>", desc = "Help Picker" },
    },
    config = function()
      require("mini.pick").setup()
    end,
  },
  {
    "echasnovski/mini.clue",
    version = false,
    event = "BufWinEnter",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        clues = {
          {
            { mode = "n", keys = "<Leader>g", desc = "+git" },
            { mode = "n", keys = "<Leader>n", desc = "+notes" },
            { mode = "n", keys = "<Leader>p", desc = "+plugins" },
            { mode = "n", keys = "<Leader>u", desc = "+ui" },
          },
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows({ submode_resize = true }),
          miniclue.gen_clues.z(),
        },

        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- mini.basics
          { mode = "n", keys = [[\]] },

          -- mini.bracketed
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        window = { config = { width = "auto", border = "double" }, delay = 500 },
      })
      -- Enable triggers in help buffer
      local clue_group = vim.api.nvim_create_augroup("my-miniclue", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "help",
        group = clue_group,
        callback = function(data)
          miniclue.enable_buf_triggers(data.buf)
        end,
      })
    end,
  },
  {
    "echasnovski/mini.statusline",
    version = "*",
    lazy = false,
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        content = {
          active = function()
            -- stylua: ignore start
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local spell         = vim.wo.spell and (statusline.is_truncated(120) and 'S' or 'SPELL') or ''
            local wrap          = vim.wo.wrap and (statusline.is_truncated(120) and 'W' or 'WRAP') or ''
            local macro         = vim.fn.reg_recording() ~= "" and ("@" .. vim.fn.reg_recording()) or ""
            local git           = statusline.section_git({ trunc_width = 75 })
            -- Default diagnstics icon has some problems displaying in Kitty terminal
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            local searchcount   = statusline.section_searchcount({ trunc_width = 75 })
            local location      = statusline.section_location({ trunc_width = 10000 })

            -- Usage of `statusline.combine_groups()` ensures highlighting and
            -- correct padding with spaces between groups (accounts for 'missing'
            -- sections, etc.)
            return statusline.combine_groups({
              { hl = mode_hl,                 strings = { mode, spell, wrap, macro } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { searchcount, location } },
            })
            -- stylua: ignore end
          end,
        },
      })
    end,
  },
  {
    "echasnovski/mini.starter",
    version = "*",
    lazy = false,
    config = function()
      require("mini.starter").setup({
        header = "           ▄ ▄                   \n"
          .. "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     \n"
          .. "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     \n"
          .. "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     \n"
          .. "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  \n"
          .. "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄\n"
          .. "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █\n"
          .. "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █\n"
          .. "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    \n",
      })
    end,
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup({})
    end,
  },
  {
    "echasnovski/mini.comment",
    version = "*",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
    },
    config = function()
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring()
              or vim.bo.commentstring
          end,
        },
      })
    end,
  },
}
