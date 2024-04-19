return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    opts = {},
    config = function(_, opts)
      -- Setup plugin
      require("toggleterm").setup(opts)

      -- Setup lazygit term
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      vim.keymap.set("n", "<leader>gg", function()
        lazygit:toggle()
      end, { silent = true, desc = "Lazygit" })
    end,
  },
}
