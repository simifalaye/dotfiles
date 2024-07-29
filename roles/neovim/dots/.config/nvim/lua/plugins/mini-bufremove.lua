local mini_bufremove = require("mini.bufremove")
mini_bufremove.setup({})

vim.keymap.set("n", "<leader>x", mini_bufremove.delete, { desc = "E[x]it Buf" })
vim.keymap.set("n", "<leader>X", mini_bufremove.wipeout, { desc = "E[x]it Buf!" })
