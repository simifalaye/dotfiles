MiniDeps.add({
  source = "folke/which-key.nvim",
})

MiniDeps.later(function()
  require("which-key").setup({
    preset = "classic",
    delay = 500,
    icons = {
      breadcrumb = "-", -- symbol used in the command line area that shows your active key combo
      separator = ":", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
      ellipsis = "…",
      -- set to false to disable all mapping icons,
      -- both those explicitly added in a mapping
      -- and those from rules
      mappings = true,
      --- See `lua/which-key/icons.lua` for more details
      --- Set to `false` to disable keymap icons from rules
      ---@type wk.IconRule[]|false
      rules = false,
      -- use the highlights from mini.icons
      -- When `false`, it will use `WhichKeyIcon` instead
      colors = true,
      keys = {
        Up = "up",
        Down = "down",
        Left = "left",
        Right = "right",
        C = "C-",
        M = "M-",
        D = "D-",
        S = "S-",
        CR = "RET",
        Esc = "ESC",
        BS = "BACK",
        Space = "SPC",
        Tab = "TAB",
        F1 = "F1",
        F2 = "F2",
        F3 = "F3",
        F4 = "F4",
        F5 = "F5",
        F6 = "F6",
        F7 = "F7",
        F8 = "F8",
        F9 = "F9",
        F10 = "F10",
        F11 = "F11",
        F12 = "F12",
      },
    },
    layout = { align = "center" },
    disable = { filetypes = { "TelescopePrompt" } },
    spec = {
      {
        mode = { "n", "v" },
        { "<C-w>", group = "+Window" },
        { "[", group = "+Prev" },
        { "]", group = "+Next" },
        { "g", group = "+Goto" },
        { "gr", group = "+Lsp" },
        { "grw", group = "+Workspace" },
        { "<leader>", group = "+Global" },
        { "<leader><tab>", group = "+Tab" },
        { "<leader>b", group = "+Buffer" },
        { "<leader>f", group = "+File" },
        { "<leader>g", group = "+Git" },
        { "<leader>s", group = "+Search" },
        { "<leader>u", group = "+Ui" },
        { "<leader>q", group = "+Quit/Session" },
        { "<leader>w", group = "+Window" },
      },
    },
  })
end)
