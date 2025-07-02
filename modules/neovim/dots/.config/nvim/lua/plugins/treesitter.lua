local ft_map = {
  PKGBUILD = "bash",
  pacscript = "bash",
  ["html.handlebars"] = "glimmer",
  ["typescript.tsx"] = "tsx",
  apkbuild = "bash",
  asm68k = "m68k",
  automake = "make",
  bib = "bibtex",
  bzl = "starlark",
  cls = "latex",
  confini = "ini",
  cs = "c_sharp",
  dosini = "ini",
  dsp = "faust",
  dts = "devicetree",
  ecma = "javascript",
  eelixir = "eex",
  eruby = "embedded_template",
  expect = "tcl",
  fsd = "facility",
  gdresource = "godot_resource",
  gdshaderinc = "gdshader",
  gitconfig = "git_config",
  gitdiff = "diff",
  gitrebase = "git_rebase",
  handlebars = "glimmer",
  haskellpersistent = "haskell_persistent",
  html_tags = "html",
  janet = "janet_simple",
  javascriptreact = "javascript",
  jproperties = "properties",
  jsx = "javascript",
  ld = "linkerscript",
  list = "commonlisp",
  mysqp = "sqp",
  neomuttrc = "muttrc",
  ocamlinterface = "ocaml_interface",
  pandoc = "markdown",
  poefilter = "poe_filter",
  qml = "qmljs",
  quarto = "markdown",
  rmd = "markdown",
  sbt = "scala",
  sface = "surface",
  sh = "bash",
  shaderslang = "slang",
  sshconfig = "ssh_config",
  sty = "latex",
  svg = "xml",
  systemverilog = "verilog",
  sysverilog = "verilog",
  tal = "uxntal",
  tape = "vhs",
  tex = "latex",
  tla = "tlaplus",
  trace32 = "t32",
  ts = "typescript",
  typescriptreact = "tsx",
  udevrules = "udev",
  vlang = "v",
  xsd = "xml",
  xslt = "xml",
}

local disabled_langs = { "tmux" }

local M = {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  branch = "main",
  build = ":TSUpdate",
}

M.cmd = { "TSUpdate", "TSInstall", "TSUpdateSync", "TSUninstall" }

M.init = function()
  -- Register langs
  for filetype, lang in pairs(ft_map) do
    vim.treesitter.language.register(lang, filetype)
  end
  -- Setup filetype autocmd to start treesitter
  vim.api.nvim_create_autocmd("BufWinEnter", {
    desc = "Enable highlighting for installed treesitter filetypes",
    pattern = { "*" },
    group = vim.api.nvim_create_augroup("user_plugin_nvim_treesitter", {}),
    callback = function(args)
      -- Start treesitter if parser installed OR install/start it if it isn't

      local treesitter = require("nvim-treesitter") -- Lazy load on require
      local bufnr = args.buf
      local filetype = vim.bo[bufnr].filetype
      if not filetype or filetype == "" then
        return
      end
      local lang = vim.treesitter.language.get_lang(filetype) or filetype
      if vim.list_contains(disabled_langs, lang) then
        return
      end

      if vim.list_contains(treesitter.get_installed(), lang) then
        vim.treesitter.start(bufnr)
      elseif vim.list_contains(treesitter.get_available(), lang) then
        treesitter.install(lang, { summary = true }):await(function()
          vim.schedule(function()
            vim.treesitter.start(bufnr)
          end)
        end)
      end
    end,
  })
end

M.config = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return M
