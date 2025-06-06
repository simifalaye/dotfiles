local M = {
  "tpope/vim-fugitive",
}

M.dependencies = { "tpope/vim-rhubarb" }

M.cmd = {
  "G",
  "GBrowse",
  "Gcd",
  "Gclog",
  "Gdiffsplit",
  "Gdrop",
  "Gedit",
  "Ggrep",
  "Git",
  "Glcd",
  "Glgrep",
  "Gllog",
  "Gpedit",
  "Gread",
  "Gsplit",
  "Gtabedit",
  "Gvdiffsplit",
  "Gvsplit",
  "Gwq",
  "Gwrite",
}

M.keys = {
  { "<leader>gb", "<cmd>Git blame<CR>", desc = "Blame" },
  { "<leader>gB", "<cmd>GBrowse<CR>", desc = "Open in remote server" },
  {
    "<leader>gd",
    "<cmd>Gdiff<CR>",
    desc = "Diff",
  },
  {
    "<leader>gD",
    "<cmd>Gdiff !~<CR>",
    desc = "Diff Head",
  },
  { "<leader>gg", "<cmd>Git<CR>", desc = "Show" },
  { "<leader>gl", "<cmd>Git log --oneline --follow -- %<CR>", desc = "Log current file" },
  { "<leader>gL", "<cmd>Git log --oneline --graph<CR>", desc = "Log current repo" },
}

M.config = function()
  local groupid = vim.api.nvim_create_augroup("user_fugitive_settings", {})

  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Ensure that fugitive buffers are not listed and are wiped out after hidden.",
    group = groupid,
    pattern = "fugitive://*",
    callback = function(info)
      vim.bo[info.buf].buflisted = false
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Set buffer-local options for fugitive buffers.",
    group = groupid,
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
    group = groupid,
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
end

return M
