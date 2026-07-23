exec_now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  })

  require("mason").setup()

  require("mason-tool-installer").setup({
    ensure_installed = {
      -- LSPs
      "basedpyright",
      "bash-language-server",
      "clangd",
      "gopls",
      "json-lsp",
      "lua-language-server",
      "marksman",
      "typescript-language-server",
      "vim-language-server",
      "yaml-language-server",

      -- Formatters
      "black",
      "clang-format",
      "gofumpt",
      "golines",
      "prettierd",
      "shfmt",
      "stylua",

      -- Linters
      "cpplint",
      "editorconfig-checker",
      "eslint_d",
      "flake8",
      "golangci-lint",
      "shellcheck",
    },

    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
  })

  require("mason-lspconfig").setup({
    automatic_enable = true,
  })
end)
