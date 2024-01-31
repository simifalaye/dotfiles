local lsp = require("utils.lsp")
local config = require("static.default_lspconfig")

if vim.fn.executable("cpplint") == 1 then
  local cpplint_config = {
    lintSource = "cpplint",
    lintCommand = 'cpplint "${INPUT}"',
    lintStdin = false,
    lintFormats = { "%.%#:%l: %m" },
    lintIgnoreExitCode = true,
  }
  lsp.start(
    lsp.generate_config(config, {
      cmd = { "efm-langserver" },
      name = "cpplint",
      settings = {
        languages = {
          c = { cpplint_config },
          cpp = { cpplint_config },
        },
      },
    }),
    nil,
    false
  )
end

lsp.start(lsp.generate_config(config, {
  name = "clangd",
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu",
  },
  root_patterns = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
  },
  on_attach = function(client, bufnr)
    -- Create switch command
    -- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
    vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
      bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
      local params = { uri = vim.uri_from_bufnr(bufnr) }
      if client then
        client.request("textDocument/switchSourceHeader", params, function(err, result)
          if err then
            error(tostring(err))
          end
          if not result then
            print("Corresponding file cannot be determined")
            return
          end
          vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
        end, bufnr)
      else
        print(
          "method textDocument/switchSourceHeader is not supported by any servers active on the current buffer"
        )
      end
    end, {
      desc = "Switch between source and header file",
    })
    -- Create switch keymap
    vim.keymap.set(
      "n",
      "<localleader><localleader>",
      "<cmd>ClangdSwitchSourceHeader<CR>",
      { buffer = bufnr, desc = "Switch src/header" }
    )
  end,
  single_file_support = true,
  capabilities = {
    offsetEncoding = {
      "utf-16",
    },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}))
