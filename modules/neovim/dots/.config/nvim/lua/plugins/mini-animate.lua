local M = {
  "echasnovski/mini.animate",
  version = "*",
}

M.event = { "BufReadPost", "BufNewFile" }

M.keys = {
  {
    "<leader>ua",
    function()
      vim.g.minianimate_disable = not vim.g.minianimate_disable
      vim.notify(
        string.format(
          "animations %s",
          require("utils.ui").bool2str(not vim.g.minianimate_disable)
        )
      )
    end,
    desc = "Toggle animations",
  },
}

M.opts = function()
  local mouse_scrolled = false
  -- don't use animate when scrolling with the mouse
  for _, scroll in ipairs({ "Up", "Down" }) do
    local key = "<ScrollWheel" .. scroll .. ">"
    vim.keymap.set({ "", "i" }, key, function()
      mouse_scrolled = true
      return key
    end, { expr = true })
  end

  local animate = require("mini.animate")
  return {
    resize = {
      timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
    },
    scroll = {
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
      subscroll = animate.gen_subscroll.equal({
        predicate = function(total_scroll)
          if mouse_scrolled then
            mouse_scrolled = false
            return false
          end
          return total_scroll > 1
        end,
      }),
    },
  }
end

return M
