local LazyMod = {}
LazyMod.__index = LazyMod

local lazy_modules = {}
local is_lazy_requiring = false
local old_require = require
require = function(name)
  if not is_lazy_requiring and lazy_modules[name] then
    is_lazy_requiring = true
    lazy_modules[name]()
    is_lazy_requiring = false
  end
  return old_require(name)
end

function LazyMod.load_mod(name)
  if lazy_modules[name] and lazy_modules[name]() then
    vim.notify("Loaded module: " .. name)
    return
  end
  vim.notify("Faild to load module: " .. name, vim.log.levels.ERROR)
end

function LazyMod.new(name, loader, mods)
  local self = setmetatable({}, LazyMod)
  name = name or ""
  loader = loader or function()
    return true
  end
  self.name = name
  self.loaded = false
  self.loader = function()
    if self.loaded then
      return true
    end
    if loader() then
      self.loaded = true
      return true
    end
    return false
  end
  -- Add lazy module loading
  if mods then
    for _, mod in pairs(mods) do
      lazy_modules[mod] = self.loader
    end
  end
  return self
end

function LazyMod:load()
  return self.loader()
end

function LazyMod:autocmds(events, pattern, cond)
  cond = cond ~= nil and cond or function()
    return true
  end
  vim.api.nvim_create_autocmd(events, {
    desc = "Lazy-load " .. self.name,
    pattern = pattern or "*",
    once = true,
    callback = function()
      if cond() then
        self:load()
      end
    end,
  })
end

function LazyMod:fts(fts)
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Lazy-load " .. self.name,
    pattern = fts,
    once = true,
    callback = function()
      self:load()
    end,
  })
end

function LazyMod:cmds(cmds)
  substr = substr or false
  for _, cmd in pairs(cmds) do
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

      self:load()

      local info = vim.api.nvim_get_commands({})[cmd]
        or vim.api.nvim_buf_get_commands(0, {})[cmd]
      if not info then
        vim.schedule(function()
          vim.notify(
            "lazy: Command '" .. cmd .. "' not lazy-loaded",
            vim.log.levels.ERROR
          )
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
        if not self.loaded and self.loader() then
          self.loaded = true
        end
        -- NOTE: return the newly loaded command completion
        return vim.fn.getcompletion(line, "cmdline")
      end,
    })
  end
end

function LazyMod:key(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, function()
    pcall(vim.keymap.del, mode, rhs, opts)

    self:load()

    if type(rhs) == "string" then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(rhs, true, true, true),
        "n",
        true
      )
    elseif type(rhs) == "function" then
      rhs()
    elseif rhs == nil then
      if mode:sub(-1) == "a" then
        lhs = lhs .. "<C-]>"
      end
      local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. lhs, true, true, true)
      -- insert instead of append the lhs
      vim.api.nvim_feedkeys(feed, "i", false)
    end
  end, opts)
end

return LazyMod
