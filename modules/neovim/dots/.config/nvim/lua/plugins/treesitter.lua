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

local M = {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  branch = "main",
  build = ":TSUpdate",
}

M.cmd = { "TSUpdate", "TSInstall", "TSUpdateSync" }

M.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable highlighting for installed treesitter filetypes",
    pattern = { "*" },
    group = vim.api.nvim_create_augroup("user_plugin_nvim_treesitter", {}),
    callback = function(args)
      -- Start treesitter if parser installed OR install and start it if it isn't
      local treesitter = require("nvim-treesitter") -- Lazy load on require
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      ft = ft_map[ft] or ft
      if vim.list_contains(treesitter.get_installed(), ft) then
        vim.treesitter.start(bufnr, ft)
      elseif vim.list_contains(treesitter.get_available(), ft) then
        treesitter.install(ft, { summary = true }):await(function()
          vim.schedule(function()
            vim.treesitter.start(bufnr, ft)
          end)
        end)
      end
    end,
  })
end

M.config = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return M
