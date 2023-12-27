return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>njj", "<cmd>Neorg journal today<cr>", desc = "Journal today" },
      { "<leader>njy", "<cmd>Neorg journal yesterday<cr>", desc = "Journal yesterday" },
      { "<leader>njt", "<cmd>Neorg journal tomorrow<cr>", desc = "Journal tomorrow" },
    },
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes1",
            },
          },
        },
        ["core.journal"] = {
          config = {
            journal_folder = "journal",
            strategy = "nested",
            template_name = "template.norg",
            use_template = true,
          },
        },
        ["core.keybinds"] = {
          config = {
            hook = function(k)
              k.remap("norg", "n", k.leader .. "T", "<cmd>Neorg toc<CR>")
              k.remap_event(
                "norg",
                "n",
                k.leader .. "c",
                "core.looking-glass.magnify-code-block"
              )
            end,
          },
        },
      },
    },
    init = function()
      local m = require("utils.map")
      m.group("<leader>n", "+notes")
      m.group("<leader>nj", "+journal")
    end,
  },
}
