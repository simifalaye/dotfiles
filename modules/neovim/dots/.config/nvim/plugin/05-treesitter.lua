local lazy = require("utils.lazy")

lazy.now_if_args(function()
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
  local ts_update = function()
    vim.cmd("TSUpdate")
  end
  lazy.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  vim.pack.add({
    {
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
    },
  })

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
  vim.list_extend(filetypes, { "markdown", "quarto" })
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
  end
  vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = filetypes, callback = ts_start, desc = "Ensure enabled tree-sitter" }
  )

  -- Miscellaneous adjustments
  vim.treesitter.language.register("markdown", "quarto")
  vim.filetype.add({
    extension = { qmd = "quarto", Qmd = "quarto" },
  })

  -- Enable folds and indent
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end)
