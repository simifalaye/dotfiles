MiniDeps.add({
  source = "tpope/vim-fugitive",
  depends = { "tpope/vim-rhubarb" },
})

MiniDeps.later(function()
  -- Autocmds
  local grp = vim.api.nvim_create_augroup("user_fugitive_settings", {})
  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Ensure that fugitive buffers are not listed and are wiped out after hidden.",
    group = grp,
    pattern = "fugitive://*",
    callback = function(info)
      vim.bo[info.buf].buflisted = false
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Set buffer-local options for fugitive buffers.",
    group = grp,
    pattern = "fugitive",
    callback = function()
      vim.opt_local.winbar = nil
      vim.opt_local.signcolumn = "no"
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Set buffer-local options for fugitive blame buffers.",
    group = grp,
    pattern = "fugitiveblame",
    callback = function()
      local win_alt = vim.fn.win_getid(vim.fn.winnr("#"))
      vim.opt_local.winbar = vim.api.nvim_win_is_valid(win_alt)
          and vim.wo[win_alt].winbar ~= ""
          and " "
        or ""

      vim.opt_local.number = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.relativenumber = false
    end,
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Blame" })
  vim.keymap.set(
    "n",
    "<leader>gB",
    "<cmd>GBrowse<CR>",
    { desc = "Open in remote server" }
  )
  vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>", { desc = "Diff" })
  vim.keymap.set("n", "<leader>gD", "<cmd>Gdiff !~<CR>", { desc = "Diff Head" })
  vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Show" })
  vim.keymap.set(
    "n",
    "<leader>gl",
    "<cmd>Git log --oneline --follow -- %<CR>",
    { desc = "Log current file" }
  )
  vim.keymap.set(
    "n",
    "<leader>gL",
    "<cmd>Git log --oneline --graph<CR>",
    { desc = "Log current repo" }
  )

  -- Setup wk group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>g", group = "+Git" } })
  end
end)
