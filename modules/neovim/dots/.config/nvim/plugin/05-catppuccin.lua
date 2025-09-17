MiniDeps.now(function()
  MiniDeps.add({
    source = "catppuccin/nvim",
  })

  require("catppuccin").setup({
    float = {
      transparent = false, -- enable transparent floating windows
      solid = false, -- use solid styling for floating windows, see |winborder|
    },
    term_colors = true,
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
end)
