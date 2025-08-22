MiniDeps.add({
  source = "saghen/blink.cmp",
  checkout = "v1.6.0",
  monitor = "main",
  depends = { "rafamadriz/friendly-snippets" },
})

MiniDeps.later(function()
  local icons = require("static.icons")
  local has_words_before = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 then
      return false
    end
    local line = vim.api.nvim_get_current_line()
    return line:sub(col, col):match("%s") == nil
  end

  local opts = {
    enabled = function()
      return vim.fn.reg_recording() == "" and vim.fn.reg_executing() == ""
    end,
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "none",
      -- If completion hasn't been triggered yet, insert the first suggestion; if it has, cycle to the next suggestion.
      ["<Tab>"] = {
        function(cmp)
          if has_words_before() then
            return cmp.insert_next()
          end
        end,
        "fallback",
      },
      -- Navigate to the previous suggestion or cancel completion if currently on the first one.
      ["<S-Tab>"] = { "insert_prev" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-.>"] = { "snippet_forward", "fallback" },
      ["<C-,>"] = { "snippet_backward", "fallback" },
      ["<C-e>"] = { "hide" },
      ["<C-y>"] = { "select_and_accept" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
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
    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      trigger = { show_in_snippet = false },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
        cycle = { from_top = false },
      },
      documentation = {
        auto_show = false,
      },
      menu = { auto_show = false },
      -- menu = {
      --   min_width = vim.go.pumwidth,
      --   max_height = vim.go.pumheight,
      --   draw = {
      --     columns = {
      --       { "label" },
      --       { "kind_icon" },
      --       { "label_description" },
      --     },
      --   },
      -- },
    },
    -- experimental signature help support
    signature = { enabled = true },
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
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
      keymap = { preset = "inherit" },
      -- completion = { menu = { auto_show = true } },
    },
  }

  -- Load plugin
  require("blink-cmp").setup(opts)
end)
