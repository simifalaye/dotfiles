local M = {
  "catppuccin/nvim",
}

M.name = "catppuccin"
M.priority = 1000

M.config = function()
  require("catppuccin").setup({
    integrations = {
      fzf = true,
      gitsigns = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
    compile_path = vim.fs.joinpath(
      vim.fn.stdpath("cache") --[[@as string]],
      "catppuccin"
    ),
  })
  vim.cmd.colorscheme("catppuccin")
end

return M
