local lz = require("utils.lazy").new("cmp", function()
  local cmp = require("cmp")
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

  -- Setup nvim-snippets/friendly-snippets
  local friendly_path = nil
  for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
    if string.match(path, "friendly.snippets") then
      friendly_path = vim.fs.joinpath(path, "snippets")
    end
  end
  require("snippets").setup({
    create_autocmd = true,
    search_paths = {
      vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "snippets"),
      friendly_path,
    },
    extended_filetypes = {
      bash = { "shell" },
      cpp = { "c" },
      sh = { "shell" },
      zsh = { "shell" },
    },
  })

  -- Insert mode setup
  cmp.setup({
    enabled = function()
      if vim.bo.buftype == "prompt" then
        return false
      end
      return not vim.b["bigfile"]
    end,
    snippet = {
      expand = function(item)
        vim.snippet.expand(item.body)
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
      format = require("lspkind").cmp_format({
        mode = "symbol",
        menu = {
          nvim_lsp = "(Lsp)",
          nvim_lua = "(Lua)",
          path = "(Path)",
          snippets = "(Snip)",
          buffer = "(Buf)",
          spell = "(Spell)",
          rg = "(Rg)",
          git = "(Git)",
          -- codeium = "(AI)",
        },
      }),
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
        elseif vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      -- { name = "codeium" },
      { name = "snippets", max_item_count = 3 },
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
  return true
end)
lz:autocmds({ "InsertEnter", "CmdlineEnter" })
