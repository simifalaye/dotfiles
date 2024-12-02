vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = vim.api.nvim_create_augroup("user_lsp_signature", {}),
  desc = "Setup lsp signature",
  callback = function(args)
    local bufnr = args.buf --[[@as number]]
    require("lsp_signature").on_attach({
      toggle_key = "<C-k>",
      toggle_key_flip_floatwin_setting = true,
    }, bufnr)
  end,
})
