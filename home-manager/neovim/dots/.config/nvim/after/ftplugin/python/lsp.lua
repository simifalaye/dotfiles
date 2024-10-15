local lsp = require("utils.lsp")
local root_patterns = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
}

local efm = false
local efm_fmt = false
local efm_cfg = {
  cmd = { "efm-langserver" },
  name = "efm",
  root_patterns = root_patterns,
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    languages = {
      python = {},
    },
  },
}

if vim.fn.executable("black") then
  local is_windows = vim.fn.has("win32") == 1
  table.insert(efm_cfg.settings.languages.python, {
    formatCanRange = not is_windows,
    formatCommand = is_windows and "black --no-color -q -"
      or "black --no-color -q $(echo ${--useless:rowStart} ${--useless:rowEnd} | xargs -n4 -r sh -c 'echo --line-ranges=$(($1+1))-$(($3+1))') -",
    formatStdin = true,
  })
  efm_fmt = true
  efm = true
end

if efm then
  lsp.start(efm_cfg)
end
lsp.start({
  name = "pyright",
  cmd = { "pyright-langserver", "--stdio" },
  root_patterns = root_patterns,
  init_options = {
    documentFormatting = not efm_fmt,
    documentRangeFormatting = not efm_fmt,
  },
  single_file_support = true,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  commands = {
    PyrightOrganizeImports = {
      function()
        local params = {
          command = "pyright.organizeimports",
          arguments = { vim.uri_from_bufnr(0) },
        }
        local clients = vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
          name = "pyright",
        })
        for _, client in ipairs(clients) do
          client.request("workspace/executeCommand", params, nil, 0)
        end
      end,
      description = "Organize Imports",
    },
    PyrightSetPythonPath = {
      function(path)
        local clients = vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
          name = "pyright",
        })
        for _, client in ipairs(clients) do
          if client.settings then
            client.settings.python =
              vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
          else
            client.config.settings = vim.tbl_deep_extend(
              "force",
              client.config.settings,
              { python = { pythonPath = path } }
            )
          end
          client.notify("workspace/didChangeConfiguration", { settings = nil })
        end
      end,
      description = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    },
  },
})
