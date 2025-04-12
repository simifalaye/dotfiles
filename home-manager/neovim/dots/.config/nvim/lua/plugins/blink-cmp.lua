return {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  dependencies = { "rafamadriz/friendly-snippets" },
  event = { "InsertEnter" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = {
      preset = "default",
    },
    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },

    -- experimental signature help support
    -- signature = { enabled = true },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
      enabled = false,
    },

    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
  },
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
  end,
}
