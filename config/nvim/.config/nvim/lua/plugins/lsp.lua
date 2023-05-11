local keymaps = function(client, bufnr)
  local m = require("utils.map")
  local o = { buffer = bufnr }

  m.nnoremap("[d", vim.diagnostic.goto_prev, "Goto prev diag (LSP)", o)
  m.nnoremap("]d", vim.diagnostic.goto_next, "Goto next diag (LSP)", o)
  m.nnoremap("gd", vim.lsp.buf.definition, "Goto def (LSP)", o)
  m.nnoremap("gD", vim.lsp.buf.declaration, "Goto decl (LSP)", o)
  if client.server_capabilities.implementation then
    m.nnoremap("gi", vim.lsp.buf.implementation, "Goto impl (LSP)", o)
  end
  m.nnoremap("gr", vim.lsp.buf.references, "Goto ref (LSP)", o)
  m.nnoremap("K", vim.lsp.buf.hover, "Hover (LSP)", o)

  m.noremap(
    { "n", "x" },
    "<localleader>a",
    vim.lsp.buf.code_action,
    "Code action",
    o
  )
  m.nnoremap("<localleader>d", vim.diagnostic.open_float, "Diagnostic line (LSP)", o)
  if client.server_capabilities.documentFormattingProvider then
    m.nnoremap("<localleader>f", vim.lsp.buf.format, "Format (LSP)", o)
  end
  m.nnoremap("<localleader>r", vim.lsp.buf.rename, "Rename (LSP)", o)
  if client.server_capabilities.type_definition then
    m.nnoremap("<localleader>t", vim.lsp.buf.type_definition, "Goto type (LSP)", o)
  end
end

local autocmds = function(client, _)
  if client and client.server_capabilities.code_lens then
    vim.api.nvim_create_autocmd({
      "BufEnter",
      "CursorHold",
      "InsertLeave",
    }, {
      desc = "Refresh codelens often",
      pattern = "<buffer>",
      callback = vim.lsp.codelens.refresh,
    })
  end
  if client and client.server_capabilities.document_highlight then
    require("utils.command").augroup("lsp_documenthighlight", {
      {
        desc = "Highlight references on cursor hold",
        event = "CursorHold",
        pattern = "<buffer>",
        callback = vim.lsp.buf.document_highlight,
      },
      {
        desc = "Clear reference highlights on cursor move",
        event = "CursorMoved",
        pattern = "<buffer>",
        callback = vim.lsp.buf.clear_references,
      },
    })
  end
end

local diagnostics = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  -- Define signs
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = "" }
    )
  end
  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
  vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return {
  {
    "neovim/nvim-lspconfig",
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
    event = "BufReadPre",
    config = function()
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")
      diagnostics()

      -- Default server options
      local default_opts = {
        on_attach = function(client, bufnr)
          autocmds(client, bufnr)
          keymaps(client, bufnr)
        end,
        capabilities = (function()
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          local cmp_lsp = _G.prequire("cmp_nvim_lsp")
          if cmp_lsp then
            capabilities = cmp_lsp.default_capabilities(capabilities)
          end
          return capabilities
        end)(),
        flags = {
          debounce_text_changes = 150,
        },
      }

      -- Setup neodev (NOTE: Must come before any lspconfig setup)
      require("neodev").setup({})
      -- Setup mason (NOTE: Must come before mason-lspconfig)
      require("mason").setup({})
      -- Setup mason-lspconfig (NOTE: Sets up lspconfig)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "bashls" },
        automatic_installation = true,
      })
      mason_lspconfig.setup_handlers({
        function(name) -- default handler
          lspconfig[name].setup(default_opts)
        end,
        ["clangd"] = function()
          local opts = {
            cmd = {
              "clangd",
              "--background-index",
              "--suggest-missing-includes",
              "--header-insertion=iwyu",
              "--offset-encoding=utf-16",
            },
          }
          opts = vim.tbl_deep_extend("force", default_opts, opts)
          lspconfig["clangd"].setup(opts)
        end,
        ["lua_ls"] = function()
          local opts = vim.tbl_deep_extend("force", default_opts, {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false, -- fixes popup issue
                }
              }
            }
          })
          lspconfig["lua_ls"].setup(opts)
        end,
      })
      -- Setup mason-null-ls (NOTE: Sets up null-ls)
      local mason_null_ls = require("mason-null-ls")
      mason_null_ls.setup({
        ensure_installed = { "stylua", "shellcheck", "cpplint" },
        automatic_installation = true,
        automatic_setup = true,
        handlers = {
          function(name, methods) -- default handler
            require("mason-null-ls.automatic_setup")(name, methods)
          end,
          stylua = function(_, _)
            null_ls.register(null_ls.builtins.formatting.stylua.with({
              extra_args = function(params)
                if _G.file_exists(_G.join_paths(params.root, "stylua.toml"))
                    or _G.file_exists(_G.join_paths(params.root, ".stylua.toml"))
                then
                  return {}
                end
                return {
                  "--column-width",
                  "80",
                  "--indent-width",
                  "2",
                  "--indent-type",
                  "Spaces",
                  "--quote-style",
                  "AutoPreferDouble",
                }
              end,
            }))
          end,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    config = function()
      -- Setup fidget
      require("fidget").setup({})
    end,
  },
}
