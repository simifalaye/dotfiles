-- tailwind-tools.lua
return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  ft = { "typesriptreact", "javascriptreact", "html", "css" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    server = {
      override = true,
      on_attach = function(_, bufnr)
        vim.keymap.set(
          "n",
          "gryc",
          "<cmd>TailwindConcealToggle",
          { desc = "Toggle tailwind conceal", buffer = bufnr }
        )
      end,
    },
    conceal = {
      enabled = true,
      min_length = 60,
    },
  }
}
