local M = {}

M.lazy_autocmd = function(name, events, load_func)
  vim.api.nvim_create_autocmd(events, {
    desc = "Lazy-load " .. name,
    once = true,
    callback = function()
      load_func()
    end,
  })
end

M.lazy_cmd = function(name, cmd, load_func)
  local def = "lazy-cmd-" .. name
  vim.api.nvim_create_user_command(cmd, function(event)
    local command = {
      cmd = cmd,
      bang = event.bang or nil,
      mods = event.smods,
      args = event.fargs,
      count = event.count >= 0 and event.range == 0 and event.count or nil,
    }

    if event.range == 1 then
      command.range = { event.line1 }
    elseif event.range == 2 then
      command.range = { event.line1, event.line2 }
    end

    load_func()

    local info = vim.api.nvim_get_commands({})[cmd]
      or vim.api.nvim_buf_get_commands(0, {})[cmd]
    if not info or info.definition == def then
      vim.schedule(function()
        vim.notify("lazy: Command '" .. cmd .. "' not lazy-loaded", vim.log.levels.ERROR)
      end)
      return
    end

    command.nargs = info.nargs
    if event.args and event.args ~= "" and info.nargs and info.nargs:find("[1?]") then
      command.args = { event.args }
    end
    vim.cmd(command)
  end, {
    bang = true,
    range = true,
    nargs = "*",
    complete = function(_, line)
      load_func()
      -- NOTE: return the newly loaded command completion
      return vim.fn.getcompletion(line, "cmdline")
    end,
    desc = def,
  })
end

M.lazy_key = function(modes, lhs, rhs, opts, load_func)
  vim.keymap.set(modes, lhs, function()
    vim.keymap.del(modes, lhs, opts)
    load_func()

    modes = type(modes) == table and modes or { modes }
    for _, mode in pairs(modes) do
      if mode:sub(-1) == "a" then
        lhs = lhs .. "<C-]>"
        break
      end
    end
    local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. lhs, true, true, true)
    -- insert instead of append the lhs
    vim.api.nvim_feedkeys(feed, "i", false)
  end, {
    desc = opts.desc,
    nowait = opts.nowait,
    -- we do not return anything, but this is still needed to make operator pending mappings work
    expr = true,
  })
end

return M
