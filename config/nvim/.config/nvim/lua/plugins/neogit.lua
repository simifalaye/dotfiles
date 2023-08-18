return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" } },
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      {
        "akinsho/git-conflict.nvim",
        lazy = false,
        version = "*",
        opts = {
          default_mappings = {
            ours = "co",
            theirs = "ct",
            none = "c0",
            both = "cb",
            next = "]x",
            prev = "[x",
          },
        },
        config = true,
      },
    },
    config = function ()
      require("utils.command").augroup("user_neogit", {
        {
          desc = "Setup keymap groups",
          event = "Filetype",
          pattern = "NeogitStatus",
          command = function()
            require("utils.map").refresh_clues()
          end,
        },
      })
      require("neogit").setup({})
    end
  },
}
