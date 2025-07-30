local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "go",
  "html",
  "java",
  "javascript",
  "json",
  "markdown",
  "nu",
  "pandoc",
  "python",
  "r",
  "regex",
  "rst",
  "rust",
  "toml",
  "tsx",
  "yaml",
  "zig",
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  branch = "main",
  build = ":TSUpdate",
}

M.lazy = false

M.config = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  -- Install required parsers
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Ensure enabled
  local filetypes = vim
    .iter(ensure_installed)
    :map(vim.treesitter.language.get_filetypes)
    :flatten()
    :totable()
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
  end
  vim.api.nvim_create_autocmd("FileType", { pattern = filetypes, callback = ts_start })

  -- Enable folds and indent
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return M
