local ok, _ = pcall(require, "efmls-configs")
if not ok then
  return {}
end

local stylua = require("efmls-configs.formatters.stylua")
stylua.formatCommand =
  "stylua --color Never --search-parent-directories ${--range-start:charStart} ${--range-end:charEnd} --stdin-filepath '${INPUT}' -"

local eslintd = require("efmls-configs.linters.eslint_d")
local prettierd = require("efmls-configs.formatters.prettier_d")

local clang_format = require("efmls-configs.formatters.clang_format")
local cpplint = require("efmls-configs.linters.cpplint")

local languages = {
  c = { cpplint, clang_format },
  cpp = { cpplint, clang_format },
  javascript = { eslintd, prettierd },
  javascriptreact = { eslintd, prettierd },
  python = { require("efmls-configs.formatters.black") },
  rust = { require("efmls-configs.formatters.rustfmt") },
  go = { require("efmls-configs.linters.golangci_lint") },
  typescript = { eslintd, prettierd },
  typescriptreact = { eslintd, prettierd },
  lua = { stylua },
}

function _G.efm_formatexpr(opts)
  opts = opts or {}
  local timeout_ms = opts.timeout_ms or 500

  if vim.list_contains({ "i", "R", "ic", "ix" }, vim.fn.mode()) then
    -- `formatexpr` is also called when exceeding `textwidth` in insert mode
    -- fall back to internal formatting
    return 1
  end

  local start_lnum = vim.v.lnum
  local end_lnum = start_lnum + vim.v.count - 1

  if start_lnum <= 0 or end_lnum <= 0 then
    return 0
  end
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr, name = "efm" })) do
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting) then
      local params = vim.lsp.util.make_formatting_params()
      local end_line = vim.fn.getline(end_lnum) --[[@as string]]
      local end_col =
        vim.lsp.util._str_utfindex_enc(end_line, nil, client.offset_encoding)
      --- @cast params +lsp.DocumentRangeFormattingParams
      params.range = {
        start = {
          line = start_lnum - 1,
          character = 0,
        },
        ["end"] = {
          line = end_lnum - 1,
          character = end_col,
        },
      }
      local response = client.request_sync(
        vim.lsp.protocol.Methods.textDocument_rangeFormatting,
        params,
        timeout_ms,
        bufnr
      )
      if response and response.result then
        vim.lsp.util.apply_text_edits(response.result, bufnr, client.offset_encoding)
        return 0
      end
    end
  end

  -- do not run builtin formatter.
  return 0
end

return {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  on_attach = function(_, bufnr)
    local ft = vim.bo[bufnr].filetype
    if not languages[ft] then
      return
    end
    for _, conf in ipairs(languages[ft]) do
      if conf.formatCommand then
        vim.bo[bufnr].formatexpr = "v:lua.efm_formatexpr()"
        vim.b[bufnr].user_lsp_preferred_format_server = "efm"
      end
    end
  end,
}
