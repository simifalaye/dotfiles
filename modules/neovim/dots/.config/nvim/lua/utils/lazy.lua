local cache = { later = {} }

local function exec_now(f, init_trace)
  local ok, err = xpcall(f, function(e)
    return debug.traceback(e .. "\n", 2)
  end)
  if ok then
    return true
  end
  init_trace = init_trace == nil and "" or ("\n\nTraceback:\n" .. init_trace)
  vim.notify("Error during safe execution: " .. err .. init_trace, vim.log.levels.WARN)
  return false
end

local function exec_later()
  local timer = assert(vim.loop.new_timer())
  local f
  f = vim.schedule_wrap(function()
    local cb = cache.later[1]
    if cb == nil then
      if not timer:is_closing() then
        timer:close()
      end
      return
    end

    table.remove(cache.later, 1)
    exec_now(cb.f, cb.trace)
    timer:start(1, 0, f)
  end)

  -- Space out executions to be sure that they don't block anything
  timer:start(1, 0, f)
end

local M = {}

--- Execute now
---@param cb function
function M.now(cb)
  exec_now(cb)
end

--- Execute now if arguments provided or later
---@param cb function
function M.now_if_args(cb)
  if vim.fn.argc(-1) > 0 then
    M.now(cb)
  else
    M.later(cb)
  end
end

--- Execute later using vim.schedule
---@param cb function
function M.later(cb)
  -- Compute traceback before delaying execution to provide more info
  local trace = debug.traceback("", 2)
  if #cache.later == 0 then
    vim.schedule(exec_later)
  end
  table.insert(cache.later, { f = cb, trace = trace })
end

--- Execute on event
---@param event string|string[]
---@param pattern string|string[]
---@param cb function
function M.event(event, pattern, cb)
  -- Compute traceback before delaying execution to provide more info
  local trace = debug.traceback("", 2)
  local id
  local group = vim.api.nvim_create_augroup("user.lazy", { clear = false })
  id = vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      if id then
        vim.api.nvim_del_autocmd(id)
      end
      exec_now(cb, trace)
    end,
    nested = true,
  })
end

--- Custom `vim.pack.add()` hook helper
---@param plugin_name string
---@param kinds string[]
---@param callback function
---@param desc string
function M.on_packchanged(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev)
  end
  vim.api.nvim_create_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

return M
