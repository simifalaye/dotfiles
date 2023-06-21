local utils = require("utils")

local M = {}

local function validate_autocmd(name, cmd)
  local keys = {
    "event",
    "buffer",
    "pattern",
    "desc",
    "command",
    "group",
    "once",
    "nested",
    "set",
  }
  local incorrect = utils.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, cmd, {})
  if #incorrect == 0 then
    return
  end
  vim.schedule(function()
    utils.notify(
      string.format(
        "Autocmd: %s: Incorrect keys: %s",
        name,
        table.concat(incorrect, ", ")
      ),
      vim.log.levels.ERROR
    )
  end)
end

---@class AutocmdArgs
---@field id number autocmd ID
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] list of autocommand events
---@field pattern string | string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number
---@field set fun() function to run when creating the autocmd

--- Create an augroup with a list of autocommands
---@param name string
---@param commands Autocommand[]
---@return integer
M.augroup = function(name, commands)
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(
    #commands > 0,
    string.format("You must specify at least one autocommand for %s", name)
  )
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    if autocmd.set and type(autocmd.set) == "function" then
      autocmd.set()
    end
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean

--- Create an nvim command
---@param name string
---@param rhs string | fun(args: CommandArgs)
---@param opts table?
M.command = function(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

return M
