local M = {}
local log = require("utils.log")

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
  }
  local incorrect = _G.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, cmd, {})
  if #incorrect == 0 then
    return
  end
  vim.schedule(function()
    log.error("Autocmd: %s: Incorrect keys: %s", name, table.concat(incorrect, ", ")
    )
  end)
end

--- Create an augroup with a list of autocommands
---@param name string
---@param commands table
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

return M
