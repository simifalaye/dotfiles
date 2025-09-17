MiniDeps.now_if_args(function()
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
    "lua",
    "markdown",
    "markdown_inline",
    "nu",
    "pandoc",
    "python",
    "r",
    "regex",
    "rst",
    "rust",
    "toml",
    "tsx",
    "query",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
  }

  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })

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
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end)
