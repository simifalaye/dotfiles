return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local prequire = require("utils.prequire")
      local lsp = require("utils.lsp")
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")

      -- Language server configuration
      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--header-insertion=iwyu",
            "--offset-encoding=utf-16",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false, -- fixes popup issue
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = schemastore.yaml.schemas(),
            },
          },
        },
      }

      -- Setup neodev (NOTE: Must come before any lspconfig setup)
      require("neodev").setup({})

      -- Setup diagnostics
      lsp.setup_diagnostics()

      -- Configure servers (use mason if available)
      local mason_lspconfig = prequire("mason-lspconfig")
      if mason_lspconfig then
        mason_lspconfig.setup_handlers({
          function(name) -- default handler
            lspconfig[name].setup(lsp.get_conf(servers[name]))
          end,
        })
      else
        for name, _ in ipairs(servers) do
          lspconfig[name].setup(lsp.get_conf(servers[name]))
        end
      end
    end,
  },
}
