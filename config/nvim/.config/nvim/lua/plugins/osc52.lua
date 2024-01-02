local function copy(lines, _)
  require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

return {
  {
    "ojroques/nvim-osc52",
    keys = {
      { "gy", mode = { "n", "x" }, desc = "System yank" },
    },
    init = function()
      -- Only use osc52 as the default provider when in SSH
      if vim.env.SSH_TTY then
        -- Make osc52 the clipboard provider
        vim.g.clipboard = {
          name = "osc52",
          copy = { ["+"] = copy, ["*"] = copy },
          paste = { ["+"] = paste, ["*"] = paste },
        }
      end
    end,
    config = function()
      require("osc52").setup({
        silent = true,
      })
      local m = require("utils.map")
      local osc52 = require("osc52")
      m.nnoremap("gy", osc52.copy_operator, "System yank", { expr = true })
      m.nmap("gyy", "<leader>y_", "System yank line")
      m.xmap("gy", osc52.copy_visual, "System yank visual")
    end,
  },
}
