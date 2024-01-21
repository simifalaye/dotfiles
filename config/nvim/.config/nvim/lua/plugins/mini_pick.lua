--- Pick from buffers
---@param local_opts table|nil
---   Possible fields:
---   - <include_current> `(boolean)` - whether to include current buffer in
---     the output. Default: `true`.
---   - <include_unlisted> `(boolean)` - whether to include |unlisted-buffer|s in
---     the output. Default: `false`.
---@param opts table|nil Options forwarded to |MiniPick.start()|
local function pick_buffers(local_opts, opts)
  local_opts = vim.tbl_deep_extend(
    "force",
    { include_current = true, include_unlisted = false },
    local_opts or {}
  )

  local buffers_output = vim.api.nvim_exec2(
    "ls" .. (local_opts.include_unlisted and "! t" or " t"),
    { output = true }
  ).output
  local cur_buf_id = vim.api.nvim_get_current_buf()
  local items = {}
  if buffers_output ~= "" then
    for _, l in ipairs(vim.split(buffers_output, "\n")) do
      local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
      local buf_id = tonumber(buf_str)
      local item = { text = name, bufnr = buf_id }
      if buf_id ~= cur_buf_id or local_opts.include_current then
        table.insert(items, item)
      end
    end
  else
    items = nil
  end
  local minipick = require("mini.pick")
  local show = minipick.config.source.show
    or function(buf_id, items_, query)
      minipick.default_show(buf_id, items_, query, { show_icons = true })
    end
  local default_opts = { source = { name = "Buffers", show = show } }
  opts =
    vim.tbl_deep_extend("force", default_opts, opts or {}, { source = { items = items } })
  return minipick.start(opts)
end

return {
  {
    "echasnovski/mini.pick",
    version = false,
    dependencies = { "echasnovski/mini.extra", version = false, config = true },
    cmd = "Pick",
    keys = {
      -- Leader + f
      { "<leader>f", "", desc = "+find" },
      { "<leader>f;", "<cmd>Pick commands<CR>", desc = "Commands" },
      { "<leader>f:", "<cmd>Pick history<CR>", desc = "History" },
      { "<leader>f'", "<cmd>Pick marks<CR>", desc = "Marks" },
      { '<leader>f"', "<cmd>Pick registers<CR>", desc = "Registers" },
      { "<leader>f.", "<cmd>Pick resume<CR>", desc = "Resume" },
      { "<leader>f/", "<cmd>Pick grep_live<CR>", desc = "Text (Live)" },
      {
        "<leader>fb",
        function()
          pick_buffers()
        end,
        desc = "Buffers",
      },
      { "<leader>ff", "<cmd>Pick files<CR>", desc = "Files" },
      { "<leader>fd", "<cmd>Pick diagnostic<CR>", desc = "Diagnostics" },
      { "<leader>fg", "<cmd>Pick grep<CR>", desc = "Grep" },
      { "<leader>fh", "<cmd>Pick help<CR>", desc = "Help" },
      { "<leader>fH", "<cmd>Pick hl_groups<CR>", desc = "Hl Groups" },
      { "<leader>fk", "<cmd>Pick keymaps<CR>", desc = "Keymaps" },
      { "<leader>fq", "<cmd>Pick list scope='quickfix'<CR>", desc = "Quickfix" },
      { "<leader>fs", "<cmd>Pick spellsuggest<CR>", desc = "Spell" },
      { "<leader>fo", "<cmd>Pick oldfiles<CR>", desc = "Oldfiles" },
      { "<leader>fO", "<cmd>Pick options<CR>", desc = "Options" },
    },
    opts = {
      mappings = {
        choose_marked = "<C-y>",

        scroll_left = "<C-h>",
        scroll_down = "<C-j>",
        scroll_up = "<C-k>",
        scroll_right = "<C-l>",
      },
    },
  },
}
