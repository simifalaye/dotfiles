local keymaps = function(client, bufnr)
  local m = require("utils.map")
  local o = { buffer = bufnr }
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  m.nnoremap("[d", vim.diagnostic.goto_prev, "Goto prev diag (LSP)", o)
  m.nnoremap("]d", vim.diagnostic.goto_next, "Goto next diag (LSP)", o)
  m.nnoremap("gd", vim.lsp.buf.definition, "Goto def (LSP)", o)
  m.nnoremap("gD", vim.lsp.buf.declaration, "Goto decl (LSP)", o)
  if client.server_capabilities.implementation then
    m.nnoremap("gi", vim.lsp.buf.implementation, "Goto impl (LSP)", o)
  end
  m.nnoremap("gr", vim.lsp.buf.references, "Goto ref (LSP)", o)
  m.nnoremap("K", vim.lsp.buf.hover, "Hover (LSP)", o)

  m.group("<leader>l", "+lsp")
  m.noremap({"n", "x"}, "<leader>la", vim.lsp.buf.code_action, "Code action", o)
  m.nnoremap("<leader>ld", vim.diagnostic.open_float, "Diagnostics", o)
  if client.server_capabilities.documentFormattingProvider then
    m.nnoremap("<leader>lf", vim.lsp.buf.format, "Format", o)
  end
  m.nnoremap("<leader>lr", vim.lsp.buf.rename, "Rename", o)
  if ft == "c" or ft == "cpp" then
    m.nnoremap("<leader>ls", "<cmd>ClangdSwitchSourceHeader<CR>", "Goto alt", o)
  end
  if client.server_capabilities.type_definition then
    m.nnoremap("<leader>lt", vim.lsp.buf.type_definition, "Goto type", o)
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
    local au_doc_hi = vim.api.nvim_create_augroup("LspDocumentHighlight", {})
    vim.api.nvim_create_autocmd("CursorHold", {
      group = au_doc_hi,
      desc = "Highlight references on cursor hold",
      pattern = "<buffer>",
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = au_doc_hi,
      desc = "Clear reference highlights on cursor move",
      pattern = "<buffer>",
      callback = vim.lsp.buf.clear_references,
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

local capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_lsp = _G.prequire("cmp_nvim_lsp")
  if cmp_lsp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/neodev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jayp0521/mason-null-ls.nvim",
    },
    event = "BufReadPre",
    config = function()
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")

      -- Define on attach handler
      local on_attach = function(client, bufnr)
        autocmds(client, bufnr)
        keymaps(client, bufnr)
      end

      -- Default server options
      local default_opts = {
        on_attach = on_attach,
        capabilities = capabilities(),
        flags = {
          debounce_text_changes = 150,
        },
      }

      -- Configure diagnostics
      diagnostics()

      -- Setup neodev (first)
      require("neodev").setup({})

      -- Setup mason
      require("mason").setup({})

      -- Setup lspconfig with mason
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "bashls" },
        automatic_installation = true,
      })
      mason_lspconfig.setup_handlers({
        function(name) -- default handler
          lspconfig[name].setup(default_opts)
        end,
        clangd = function()
          local opts = {
            cmd = {
              "clangd",
              "--background-index",
              "--suggest-missing-includes",
              "--header-insertion",
              "iwyu",
            },
          }
          opts = vim.tbl_deep_extend("force", default_opts, opts)
          lspconfig["clangd"].setup(opts)
        end,
        yamlls = function()
          local opts = {
            yaml = {
              schemaStore = { enable = true },
            },
          }
          opts = vim.tbl_deep_extend("force", default_opts, opts)
          lspconfig["yamlls"].setup(opts)
        end,
      })

      -- Setup null-ls with mason
      local mason_null_ls = require("mason-null-ls")
      mason_null_ls.setup({
        ensure_installed = { "stylua", "shellcheck" },
        automatic_installation = true,
        automatic_setup = true,
      })
      mason_null_ls.setup_handlers({
        function(name, methods) -- default handler
          require("mason-null-ls.automatic_setup")(name, methods)
        end,
        stylua = function(_, _)
          null_ls.register(null_ls.builtins.formatting.stylua.with({
            extra_args = function(params)
              if
                _G.file_exists(_G.join_paths(params.root, "stylua.toml"))
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
      })
      null_ls.setup()
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
