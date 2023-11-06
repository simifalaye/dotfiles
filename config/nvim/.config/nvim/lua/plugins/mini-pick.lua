return {
  {
    "echasnovski/mini.pick",
    version = false,
    dependencies = { "echasnovski/mini.extra", version = false, config = true },
    cmd = "Pick",
    keys = {
      { "<leader>f", "<cmd>Pick files<CR>", desc = "File Picker" },
      { "<leader>F", "<cmd>Pick oldfiles<CR>", desc = "Recent File Picker" },
      {
        "<leader>b",
        function()
          local buffers_output = vim.api.nvim_exec2("ls t", { output = true }).output
          if buffers_output == "" then
            require("utils").notify("No open buffers.")
            return
          end
          local cur_buf_id = vim.api.nvim_get_current_buf()
          local items = {}
          local curr_item = {}
          for _, l in ipairs(vim.split(buffers_output, "\n")) do
            P("Buf line:" .. l)
            local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
            local buf_id = tonumber(buf_str)
            local item = { text = name, bufnr = buf_id }
            if buf_id ~= cur_buf_id then
              table.insert(items, item)
            else
              curr_item = item
            end
          end
          table.insert(items, curr_item)
          local minipick = require("mini.pick")
          local show = minipick.config.source.show
            or function(buf_id, items_, query)
              minipick.default_show(buf_id, items_, query, { show_icons = true })
            end
          local opts = { source = { name = "Buffers", show = show, items = items } }
          return minipick.start(opts)
        end,
        desc = "Buffer Picker",
      },
      { "<leader>:", "<cmd>Pick commands<CR>", desc = "Commands Picker" },
      { "<leader>.", "<cmd>Pick resume<CR>", desc = "Resume Picker" },
      { "<leader>/", "<cmd>Pick grep_live<CR>", desc = "Grep Picker" },
      { "<leader>,", "<cmd>Pick help<CR>", desc = "Help Picker" },
    },
    opts = {},
  },
}
