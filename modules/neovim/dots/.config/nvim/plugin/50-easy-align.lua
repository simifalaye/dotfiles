vim.pack.add({
  { src = "https://github.com/junegunn/vim-easy-align" },
})

vim.cmd.packadd("vim-easy-align")
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Easy Align", noremap = false })
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "Easy Align", noremap = false })
