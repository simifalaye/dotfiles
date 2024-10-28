require("blink-cmp").setup({
  keymap = {
    show = "<C-space>",
    hide = "<C-e>",
    accept = "<CR>",
    select_prev = { "<Up>", "<C-p>", "<S-Tab>" },
    select_next = { "<Down>", "<C-n>", "<Tab>" },

    show_documentation = "<C-space>",
    hide_documentation = "<C-space>",
    scroll_documentation_up = "<C-u>",
    scroll_documentation_down = "<C-d>",

    snippet_forward = "<Tab>",
    snippet_backward = "<S-Tab>",
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
})
