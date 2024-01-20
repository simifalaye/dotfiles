local lsp = require("utils.lsp")
-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(client, bufnr)
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
end

lsp.register_attach_handler(function(client, bufnr)
  if client.name ~= "clangd" then
    return
  end

  -- Create switch command
  vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
    switch_source_header(client, bufnr)
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
end, 5)

lsp.start(lsp.generate_config(require("static.lspconfig"), {
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