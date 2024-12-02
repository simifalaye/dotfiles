-- TODO: Evaluate whether to re-install blink.cmp
local lz = require("utils.lazy").new("blink-cmp", function()
  local opts = {
    keymap = {
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-j>"] = { "snippet_forward", "fallback" },
      ["<C-k>"] = { "snippet_backward", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-e>"] = { "hide" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    windows = {
      autocomplete = {
        selection = "auto_insert",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        update_delay_ms = 50,
      },
    },
    trigger = {
      signature_help = { enabled = true },
    },
    accept = { auto_brackets = { enabled = true } },
    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "snippets", "buffer" },
      },
    },
  }

  local _, lazydev_ok = pcall(require, "lazydev")
  if lazydev_ok then
    vim.list_extend(opts.sources.completion.enabled_providers, { "lazydev" })
    opts.sources.providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
      lsp = { fallback_for = { "lazydev" } },
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
    })
  end

  require("blink-cmp").setup(opts)
  return true
end)
lz:events({ "InsertEnter" })
