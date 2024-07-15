local lz = require("utils.lazy").new("indent-blankline", function()
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
  return true
end)
lz:autocmds({ "BufRead" })
