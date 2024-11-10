local lz = require("utils.lazy").new("blink-cmp", function()
  require("blink-cmp").setup({
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
        selection = "manual",
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
  })
  return true
end)
lz:events({ "InsertEnter" })
