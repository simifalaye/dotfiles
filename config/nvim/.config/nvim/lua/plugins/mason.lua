return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    build = ":MasonUpdate",
    lazy = false,
    config = function()
      -- Setup mason
      require("mason").setup()

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup()

      -- Setup mason-tool-installer
      require("mason-tool-installer").setup({
        -- a list of all tools you want to ensure are installed upon
        -- start; they should be the names Mason uses for each tool
        ensure_installed = {
          "ansible-language-server", -- NOTE: node version matters
          "ansible-lint", -- NOTE: node version matters
          "bash-language-server",
          "clangd",
          "cpplint",
          "clang-format",
          "lua-language-server",
          "marksman",
          "prettier",
          "stylua",
          "shellcheck",
          "shfmt",
          "json-lsp", -- NOTE: node version matters
          "yaml-language-server", -- NOTE: node version matters
        },
        auto_update = false,
        run_on_start = true,
        -- set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 3000, -- 3 second delay
        -- Only attempt to install if 'debounce_hours' number of hours has
        -- elapsed since the last time Neovim was started. This stores a
        -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
        -- This is only relevant when you are using 'run_on_start'. It has no
        -- effect when running manually via ':MasonToolsInstall' etc....
        -- Default: nil
        debounce_hours = 5, -- at least 5 hours between attempts to install/update
      })
    end,
  },
}
