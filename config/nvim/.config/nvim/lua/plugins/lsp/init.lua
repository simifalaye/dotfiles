local prequire = require("utils.prequire")
local utils = require("utils")
local get_provider = function (name)
  return "plugins.lsp.providers." .. name
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/neodev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          "jayp0521/mason-null-ls.nvim",
        },
        config = true,
      },
    },
    config = function()
      -- Setup neodev (NOTE: Must come before any lspconfig setup)
      require("neodev").setup({})

      local lsp = require("utils.lsp")
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")
      local mason = require("mason")

      -- Default server options
      local default_opts = {
        on_attach = function(client, bufnr)
          lsp.on_attach(client, bufnr)
        end,
        capabilities = (function()
          local capabilities = lsp.capabilities
          local cmp_lsp = prequire("cmp_nvim_lsp")
          if cmp_lsp then
            capabilities = cmp_lsp.default_capabilities(capabilities)
          end
          return capabilities
        end)(),
        flags = lsp.flags,
      }

      -- Setup diagnostics
      lsp.setup_diagnostics()
      -- Setup mason
      mason.setup({})
      -- Setup mason-lspconfig (NOTE: MUST come after mason setup)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "bashls" },
        automatic_installation = true,
      })
      mason_lspconfig.setup_handlers({
        function(name) -- default handler
          local opts = default_opts
          local provider = prequire(get_provider(name))
          if provider and type(provider) == "table" then
            opts = utils.extend_tbl(opts, provider)
          end
          lspconfig[name].setup(opts)
        end,
      })
      -- Setup mason-null-ls (NOTE: MUST come after mason setup)
      local mason_null_ls = require("mason-null-ls")
      mason_null_ls.setup({
        ensure_installed = { "stylua", "shellcheck", "cpplint" },
        automatic_installation = true,
        automatic_setup = true,
        handlers = {
          function(name, methods) -- default handler
            local provider = prequire(get_provider(name))
            if provider and type(provider) == "function" then
              provider(name, methods)
            else
              require("mason-null-ls.automatic_setup")(name, methods)
            end
          end,
        },
      })
      -- Setup null-ls (NOTE: MUST come after mason-null-ls)
      null_ls.setup({})
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    config = function()
      -- Setup fidget
      require("fidget").setup({})
    end,
  },
}
