return {
  {
    "kdheepak/lazygit.nvim",
    enabled = function()
      return vim.fn.executable("lazygit") == 1
    end,
    cmd = {
      "LazyGit",
      "LazyGitCurrentFile",
      "LazyGitConfig",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>g", "<leader>g", desc = "+git" },
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
