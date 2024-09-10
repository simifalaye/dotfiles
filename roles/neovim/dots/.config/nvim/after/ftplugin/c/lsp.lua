-- NOTE: This file is loaded for cpp files also by default

local lsp = require("utils.lsp")
local root_patterns = {
  ".clangd",
  ".clang-tidy",
  ".clang-format",
  "compile_commands.json",
  "compile_flags.txt",
  "configure.ac",
}

local efm = false
local efm_cfg = {
  cmd = { "efm-langserver" },
  name = "efm",
  root_patterns = root_patterns,
  settings = {
    languages = {
      c = {},
      cpp = {},
    },
  },
}

if vim.fn.executable("cpplint") == 1 then
  local cpplint = {
    lintSource = "cpplint",
    lintCommand = 'cpplint "${INPUT}"',
    lintStdin = false,
    lintFormats = { "%.%#:%l: %m" },
    lintIgnoreExitCode = true,
  }
  table.insert(efm_cfg.settings.languages.c, cpplint)
  table.insert(efm_cfg.settings.languages.cpp, cpplint)
  efm = true
end

if efm then
  lsp.start(efm_cfg)
end
lsp.start({
  name = "clangd",
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
  root_patterns = root_patterns,
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
  on_attach = function(client, bufnr)
    -- Create switch command
    -- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
    vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
      if client.name ~= "clangd" then
        return
      end
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
})
