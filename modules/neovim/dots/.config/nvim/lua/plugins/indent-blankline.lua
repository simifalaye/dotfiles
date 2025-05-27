local M = {
  "lukas-reineke/indent-blankline.nvim",
  version = "*",
  main = "ibl",
}

M.event = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@module "ibl"
---@type ibl.config
M.opts = {
  indent = {
    char = "│",
    tab_char = "│",
  },
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
}

return M
