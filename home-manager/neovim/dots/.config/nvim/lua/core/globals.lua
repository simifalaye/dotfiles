local g = vim.g

local function set_default_global(key, default)
  vim.g[key] = vim.g[key] and vim.g[key] or default
end

-- Set leader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- enable or disable automatic codelens refreshing for lsp that support it
set_default_global("user_codelens_enabled", true)

-- set the visibility of diagnostics in the UI (0=off,1=+status,2=+signs,3=all)
set_default_global("user_diagnostics_mode", 2)

-- enable LSP semantic tokens on startup
set_default_global("user_semantic_tokens_enabled", true)

-- enable or disable inlay hints
set_default_global("user_inlay_hints_enabled", true)

-- enable rooter
set_default_global("user_rooter_enabled", true)

-- enable diagnostic hover
set_default_global("user_diagnostic_hover", true)

-- Process the log level environment variable if set
if vim.env.USER_LOG_LEVEL and type(vim.env.USER_LOG_LEVEL) == "string" then
  local lvl = tonumber(vim.env.USER_LOG_LEVEL)
  if lvl >= vim.log.levels.TRACE and lvl <= vim.log.levels.OFF then
    g.user_log_level = lvl
  end
else
  g.user_log_level = vim.log.levels.INFO
end

-- Set diagnostic signs
local icons = require("static.icons")
local signs = {
  { name = "DiagnosticSignError", text = icons.font.diagnostics.error },
  { name = "DiagnosticSignWarn", text = icons.font.diagnostics.warn },
  { name = "DiagnosticSignHint", text = icons.font.diagnostics.hint },
  { name = "DiagnosticSignInfo", text = icons.font.diagnostics.info },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Diagnostics
local default_diagnostics = {
  virtual_text = true,
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
_G.user_diagnostics = {
  -- diagnostics off
  [0] = vim.tbl_deep_extend("force", default_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }),
  -- status only
  vim.tbl_deep_extend(
    "force",
    default_diagnostics,
    { virtual_text = false, signs = false }
  ),
  -- virtual text off, signs on
  vim.tbl_deep_extend("force", default_diagnostics, { virtual_text = false }),
  -- all diagnostics on
  default_diagnostics,
}
vim.diagnostic.config(_G.user_diagnostics[vim.g.user_diagnostics_mode])

-- Use clip.exe for wsl when available
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end
if vim.fn.executable("clip.exe") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    -- Don't paste from clipboard, rely on using C-S-V
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

-- Disable unused builtin plugins
g.loaded_netrw = true
g.loaded_netrwPlugin = true
g.loaded_netrwSettings = true
g.loaded_netrwFileHandlers = true
g.loaded_gzip = true
g.loaded_zip = true
g.loaded_zipPlugin = true
g.loaded_tar = true
g.loaded_tarPlugin = true
g.loaded_tutor_mode_plugin = true
g.loaded_getscript = true
g.loaded_getscriptPlugin = true
g.loaded_vimball = true
g.loaded_vimballPlugin = true
g.loaded_tohtml = true
g.loaded_2html_plugin = true

--- Inspect the contents of an object very quickly
--- ex. P({1,2,3})
--- @vararg any
--- @return any
_G.P = function(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

--- Wrapper around a module to require it before using any table members
---@param module string module to use
---@return table a metatable of the module
_G.reqcall = function(module)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(module)[k](...)
      end
    end,
  })
end
