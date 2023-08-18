return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
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
          -- TODO: Setup ansible server (note, newer versions require a higher
          -- nodejs version which isn't installed in my ubuntu version)
          -- See: https://ansible.readthedocs.io/projects/language-server/changelog/
          -- { "ansible-language-server", version = "1.0.2" },
          -- "ansible-lint",
          "clangd",
          "cpplint",
          "clang-format",
          "lua-language-server",
          "stylua",
          "shellcheck",
          "shfmt",
          -- Versions: https://www.npmjs.com/package/vscode-langservers-extracted/v/4.0.0?activeTab=versions
          { "json-lsp", version = "2.3.0", auto_update = false }, -- Node compatability (ubuntu 22.04)
          { "yaml-language-server", version = "1.10.0", auto_update = false }, -- Node compatability (ubuntu 22.04)
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
