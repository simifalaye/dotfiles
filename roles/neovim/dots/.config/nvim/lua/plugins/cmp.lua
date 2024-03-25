local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        tag = "v2.2.0",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        config = function()
          vim.tbl_map(function(type)
            require("luasnip.loaders.from_" .. type).lazy_load()
          end, { "vscode", "snipmate", "lua" })
          vim.api.nvim_create_user_command(
            "LuaSnipEditS",
            require("luasnip.extras.snip_location").jump_to_active_snippet,
            {}
          )
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
      },
      -- {
      --   "Exafunction/codeium.nvim",
      --   dependencies = {
      --     "nvim-lua/plenary.nvim",
      --     "hrsh7th/nvim-cmp",
      --   },
      --   config = true,
      -- },
    },
    event = { "InsertEnter" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local border_opts = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }
      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end

      -- Insert mode setup
      cmp.setup({
        enabled = function()
          if vim.bo.buftype =="prompt" then
            return false
          end
          return not vim.b["bigfile"]
        end,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = kind_icons[vim_item.kind]
            -- Source
            vim_item.menu = ({
              nvim_lsp = "(Lsp)",
              nvim_lua = "(Lua)",
              path = "(Path)",
              luasnip = "(Snip)",
              buffer = "(Buf)",
              spell = "(Spell)",
              rg = "(Rg)",
              git = "(Git)",
              -- codeium = "(AI)",
            })[entry.source.name] or "(Unknown)"
            return vim_item
          end,
          expandable_indicator = true,
        },
        mapping = {
          ["<PageUp>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          }),
          ["<PageDown>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          }),
          ["<Up>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ["<Down>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          -- { name = "codeium" },
          { name = "luasnip", max_item_count = 3 },
          { name = "nvim_lsp_signature_help" },
          {
            name = "nvim_lsp",
            max_item_count = 20,
          },
          { name = "buffer", max_item_count = 8 },
          { name = "path" },
        }),
        sorting = {
          priority_weight = 1.5,
          comparators = {
            cmp.config.compare.kind,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.exact,
            cmp.config.compare.score,
          },
        },
      })

      -- `/` and `?` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline("?", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = {
          ["<Tab>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-Tab>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<C-e>"] = {
            c = cmp.mapping.abort(),
          },
          ["<C-y>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
}
