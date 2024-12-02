-- TODO: Evaluate whether to re-install care.nvim
require("care").setup({
  enabled = function()
    local enabled = false
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
      enabled = false
    end
    if vim.b["midfile"] then
      enabled = false
    end
    return enabled
  end,
  confirm_behavior = "replace",
})

vim.keymap.set("i", "<CR>", "<Plug>(CareConfirm)", { desc = "Completion accept" })
vim.keymap.set("i", "<C-n>", "<Plug>(CareSelectNext)", { desc = "Completion next" })
vim.keymap.set("i", "<C-p>", "<Plug>(CareSelectPrev)", { desc = "Completion prev" })
vim.keymap.set("i", "<Tab>", "<Plug>(CareSelectNext)", { desc = "Completion next" })
vim.keymap.set("i", "<S-Tab>", "<Plug>(CareSelectPrev)", { desc = "Completion prev" })
vim.keymap.set("i", "<C-e>", "<Plug>(CareClose)", { desc = "Completion close" })
vim.keymap.set("i", "<c-d>", function()
  if require("care").api.doc_is_open() then
    require("care").api.scroll_docs(4)
  else
    vim.api.nvim_feedkeys(vim.keycode("<c-d>"), "n", false)
  end
end, { desc = "Completion docs scroll down" })
vim.keymap.set("i", "<c-u>", function()
  if require("care").api.doc_is_open() then
    require("care").api.scroll_docs(-4)
  else
    vim.api.nvim_feedkeys(vim.keycode("<c-u>"), "n", false)
  end
end, { desc = "Completion docs scroll up" })
vim.keymap.set("i", "<C-f>", function()
  local documentation = require("care").api.get_documentation()
  if #documentation == 0 then
    return
  end
  local old_win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd("s")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].ft = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, documentation)
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_set_current_win(old_win)
  -- Close care window
  require("care").api.close()
end, { desc = "Completion open docs" })
vim.keymap.set("i", "<c-j>", function()
  vim.snippet.jump(1)
end, { desc = "Snippet jump next" })
vim.keymap.set("i", "<c-k>", function()
  vim.snippet.jump(-1)
end, { desc = "Snippet jump prev" })
