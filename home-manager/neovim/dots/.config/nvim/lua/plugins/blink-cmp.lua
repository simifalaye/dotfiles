return {
  {
    "saghen/blink.cmp",
    -- use a release tag to download pre-built binaries
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "default" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      local lazydev_ok, _ = pcall(require, "lazydev")
      if lazydev_ok then
        opts.sources = vim.tbl_deep_extend("force", opts.sources, {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        })
      end

      local cmp = require("blink.cmp")
      cmp.setup(opts)

      local lsp = require("utils.lsp")
      lsp.default_config.capabilities = cmp.get_lsp_capabilities(lsp.capabilities)
    end,
  },
}
