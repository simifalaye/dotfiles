vim.o.timeout = true
vim.o.timeoutlen = 300

local function init()
  require("which-key").setup({
    plugins = { spelling = true },
    window = {
      border = "single",
    },
    layout = {
      align = "left",
    },
    disable = { filetypes = { "TelescopePrompt" } },
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Load cmp",
  once = true,
  callback = function()
    init()
  end,
})
