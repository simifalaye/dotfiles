local function init()
  require("ibl").setup({
    indent = { char = "▏" },
    scope = { show_start = false, show_end = false },
    exclude = {
      buftypes = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "aerial",
        "alpha",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "NvimTree",
        "neogitstatus",
        "notify",
        "startify",
        "toggleterm",
        "Trouble",
      },
    },
  })
end

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Load indent-blankline plugin",
  once = true,
  callback = function()
    init()
  end,
})
