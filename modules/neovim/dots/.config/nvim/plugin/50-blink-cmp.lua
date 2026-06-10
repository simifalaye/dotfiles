_G.now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  }, { load = function() end })

  vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    once = true,
    callback = function()
      vim.cmd.packadd("blink.cmp")

      local icons = require("static.icons")
      require("blink-cmp").setup({
        enabled = function()
          return vim.fn.reg_recording() == "" and vim.fn.reg_executing() == ""
        end,
        keymap = {
          preset = "default",
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
          -- Conflict with readline's keymap
          ["<C-k>"] = false,
          ["<C-f>"] = false,
          ["<C-s>"] = { "show_signature", "fallback" },
          ["<C-e>"] = {
            function(cmp)
              local hide_success = cmp.hide()
              local hide_signature_success = cmp.hide_signature()
              return hide_success or hide_signature_success
            end,
            "fallback",
          },
        },
        appearance = {
          kind_icons = {
            Text = icons.Font.Kinds.Text,
            Method = icons.Font.Kinds.Method,
            Function = icons.Font.Kinds.Function,
            Constructor = icons.Font.Kinds.Constructor,
            Field = icons.Font.Kinds.Field,
            Variable = icons.Font.Kinds.Variable,
            Property = icons.Font.Kinds.Property,
            Class = icons.Font.Kinds.Class,
            Interface = icons.Font.Kinds.Interface,
            Struct = icons.Font.Kinds.Struct,
            Module = icons.Font.Kinds.Module,
            Unit = icons.Font.Kinds.Unit,
            Value = icons.Font.Kinds.Value,
            Enum = icons.Font.Kinds.Enum,
            EnumMember = icons.Font.Kinds.EnumMember,
            Keyword = icons.Font.Kinds.Keyword,
            Constant = icons.Font.Kinds.Constant,
            Snippet = icons.Font.Kinds.Snippet,
            Color = icons.Font.Kinds.Color,
            File = icons.Font.Kinds.File,
            Reference = icons.Font.Kinds.Reference,
            Folder = icons.Font.Kinds.Folder,
            Event = icons.Font.Kinds.Event,
            Operator = icons.Font.Kinds.Operator,
            TypeParameter = icons.Font.Kinds.TypeParameter,
          },
        },
        completion = {
          -- Don't select by default, auto insert on selection
          list = { selection = { preselect = false, auto_insert = true } },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            window = {
              border = "solid",
            },
          },
        },
        signature = { enabled = true },
        cmdline = {
          completion = {
            list = {
              selection = {
                preselect = false,
                auto_insert = true,
              },
            },
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            lsp = {
              -- Don't wait for LSP completions for a long time before fallback to
              -- buffer completions
              -- - https://github.com/Saghen/blink.cmp/issues/2042
              -- - https://cmp.saghen.dev/configuration/sources.html#show-buffer-completions-with-lsp
              timeout_ms = 500,
            },
            cmdline = {
              -- ignores cmdline completions when executing shell commands
              enabled = function()
                return vim.fn.getcmdtype() ~= ":"
                  or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
              end,
            },
          },
        },
        fuzzy = {
          implementation = "prefer_rust",
        },
      })
    end,
  })
end)
