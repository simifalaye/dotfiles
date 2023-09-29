local obsidian_vault = ""
if vim.env.OBSIDIAN_VAULT and type(vim.env.OBSIDIAN_VAULT) == "string" then
  obsidian_vault = vim.env.OBSIDIAN_VAULT
end

return {
  {
    "epwalsh/obsidian.nvim",
    enabled = obsidian_vault ~= "",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
    },
    keys = {
      { "<leader>n/", "<cmd>ObsidianSearch<CR>", "Search" },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<CR>", "Find" },
      { "<leader>nn", "<cmd>ObsidianQuickSwitch<CR>", "New" },
      { "<leader>nt", "<cmd>ObsidianToday<CR>", "Today" },
      { "<leader>ny", "<cmd>ObsidianYesterday<CR>", "Yesterday" },
    },
    opts = {
      dir = obsidian_vault,
      notes_subdir = "notes",
      daily_notes = {
        folder = "notes/daily",
      },
      templates = {
        subdir = "templates",
      },
      completion = {
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir",
        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = true,
      },
      mappings = {},
    },
    init = function()
      local m = require("utils.map")

      -- Set keymap group
      m.group("<leader>n", "+notes")
      -- Set autocommands
      require("utils.command").augroup("user_obsidian", {
        {
          desc = "Load obsidian plugin and set buffer keymaps",
          event = {
            "BufReadPre " .. obsidian_vault .. "/**.md",
          },
          command = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local o = { buffer = bufnr }

            -- Load plugin
            require("lazy").load({ plugins = { "obsidian.nvim" } })

            -- Set keymaps
            m.nnoremap(
              "<localleader>b",
              "<cmd>ObsidianBacklinks<CR>",
              "Show Backlinks",
              o
            )
            m.nnoremap("<localleader>f", "<cmd>ObsidianFollowLink<CR>", "Follow link", o)
            m.nnoremap("<localleader>o", "<cmd>ObsidianOpen<CR>", "Open in Obsidian", o)
            m.xnoremap("<localleader>l", ":ObsidianLink<CR>", "Link Note", o)
            m.xnoremap("<localleader>L", ":ObsidianLinkNew<CR>", "Link New Note", o)
          end,
        },
      })
    end,
  },
}
