---@class LazyMod
local LazyMod = {}
LazyMod.__index = LazyMod

local lazy_modules = {}

--- Create lazy module
---@param name string
---@param loader fun():boolean method to load the module
---@return LazyMod
function LazyMod.new(name, loader)
  ---@class LazyMod
  local self = setmetatable({}, LazyMod)
  self.name = name
  self.loaded = false
  self.load = function()
    if self.loaded then
      return true
    end
    if loader() then
      self.loaded = true
      return true
    end
    return false
  end
  self.group = vim.api.nvim_create_augroup("user_lazy_" .. self.name, {})
  lazy_modules[name] = self.load

  return self
end

--- Ensure a module is loaded
--- (used when you have a dependency on another module which could be lazy-loaded)
---@param name string
---@return boolean true if module loaded successfully, is loaded, or a is not a lazy module
function LazyMod.ensure_module(name)
  if not lazy_modules[name] then
    return true
  end
  return lazy_modules[name]()
end

--- Load module on neovim events
---@param events string[]
---@param pattern? string autocmd pattern string to use
---@param cond? fun():boolean conditional load on event
function LazyMod:events(events, pattern, cond)
  cond = cond ~= nil and cond or function()
    return true
  end
  vim.api.nvim_create_autocmd(events, {
    group = self.group,
    desc = "Lazy-load " .. self.name,
    pattern = pattern or "*",
    once = true,
    callback = function()
      if cond() then
        self.load()
      end
    end,
  })
end

--- Load module on ft events for specific filetypes
---@param fts string[]
function LazyMod:fts(fts)
  vim.api.nvim_create_autocmd("FileType", {
    group = self.group,
    desc = "Lazy-load " .. self.name,
    pattern = fts,
    once = true,
    callback = function()
      self.load()
    end,
  })
end

--- Load module on commands
---@param cmds string[]
function LazyMod:cmds(cmds)
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

      self.load()

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
        self.load()
        -- NOTE: return the newly loaded command completion
        return vim.fn.getcompletion(line, "cmdline")
      end,
    })
  end
end

--- Load module on keymaps
---@param mode string|string[]
---@param lhs string
---@param rhs string|fun()
---@param opts table keymap options
function LazyMod:key(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, function()
    pcall(vim.keymap.del, mode, rhs, opts)

    self.load()

    if type(rhs) == "string" then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(rhs, true, true, true),
        "n",
        true
      )
    elseif type(rhs) == "function" then
      rhs()
    elseif rhs == nil then
      if type(mode) == "string" and mode:sub(-1) == "a" then
        lhs = lhs .. "<C-]>"
      end
      local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. lhs, true, true, true)
      -- insert instead of append the lhs
      vim.api.nvim_feedkeys(feed, "i", false)
    end
  end, opts)
end

return LazyMod
