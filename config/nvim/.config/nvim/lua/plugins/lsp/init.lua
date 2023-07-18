local prequire = require("utils.prequire")
local utils = require("utils")
local mod = (...):gsub("%.init$", "")
local get_provider = function (name)
  return prequire(mod .. ".providers." .. name)
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
      local default_opts = {
        on_attach = lsp.on_attach,
        capabilities = lsp.get_capabilities(),
        flags = lsp.flags,
      }

      -- Setup diagnostics
      lsp.setup_diagnostics()
      -- Setup mason
      mason.setup({})
      -- Setup mason-lspconfig (NOTE: MUST come after mason setup)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = true,
      })
      mason_lspconfig.setup_handlers({
        function(name) -- default handler
          local opts = default_opts
          local provider = get_provider(name)
          if provider and type(provider) == "table" then
            opts = utils.extend_tbl(opts, provider)
            if opts.on_attach_ext then
              local oa = opts.on_attach
              local oa_ext = opts.on_attach_ext
              opts.on_attach = function(client, bufnr)
                oa(client, bufnr)
                oa_ext(client, bufnr)
              end
              opts.on_attach_ext = nil
            end
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
            local provider = get_provider(name)
            if provider and type(provider) == "function" then
              provider(name, methods)
            else
              require("mason-null-ls.automatic_setup")(name, methods)
            end
          end,
        },
      })
      -- Setup null-ls (NOTE: MUST come after mason-null-ls)
      null_ls.setup({
        on_attach = lsp.on_attach,
      })
      -- Setup the formatting filter to prefer null-ls when available
      lsp.set_format_filter(function(c)
        local bufnr = vim.api.nvim_get_current_buf()
        local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local generators = require("null-ls.generators").get_available(
          file_type,
          require("null-ls.methods").internal.FORMATTING
        )
        -- If there is a null-ls generator, use null-ls formatting instead
        if #generators > 0 then
          return c.name == "null-ls"
        end
        return c.name ~= "null-ls"
      end)
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    config = true,
  },
}
