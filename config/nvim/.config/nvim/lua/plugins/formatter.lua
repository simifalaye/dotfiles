return {
  {
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatWrite" },
    keys = {
      { "<leader>=", "<cmd>Format<CR>", desc = "Format Document" },
      { "<leader>=", ":Format<CR>", desc = "Format Document", mode = "v" },
    },
    config = function()
      require("formatter").setup({
        logging = false,
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          cpp = { require("formatter.filetypes.cpp").clangformat },
          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
        },
      })
    end,
  },
}
