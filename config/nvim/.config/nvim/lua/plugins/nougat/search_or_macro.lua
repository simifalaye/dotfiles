local Item = require("nougat.item")

local macro_recording = {
  hidden = function(_, _)
    return vim.fn.reg_recording() == ""
  end,
  content = function(_, _)
    return "@" .. vim.fn.reg_recording()
  end,
}

local search_count = Item({
  hidden = function(_, ctx)
    return not macro_recording:hidden(ctx) or vim.v.hlsearch == 0
  end,
  prepare = function(self, _)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.ctx.search = search
    end
  end,
  content = function(self, _)
    local search = self.ctx.search
    return string.format(
      "[%d/%d]",
      search.current,
      math.min(search.total, search.maxcount)
    )
  end,
})

local M = {}

function M.create(opts)
  opts = opts or {}
  local item = Item({
    priority = opts.priority,
    hidden = function(_, _)
      return vim.o.cmdheight ~= 0
    end,
    hl = opts.hl,
    sep_left = opts.sep_left,
    prefix = opts.prefix,
    content = {
      macro_recording,
      search_count,
    },
    suffix = opts.suffix,
    sep_right = opts.sep_right,
    on_click = opts.on_click,
    context = opts.context,
  })

  return item
end

return M
