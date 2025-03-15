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
    { include_current = false, include_unlisted = false },
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
    enabled = false,
    version = false,
    dependencies = { { "echasnovski/mini.extra", version = false, config = true } },
    cmd = "Pick",
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({ { "<leader>g", group = "+git" } })
      end
    end,
    keys = {
      {
        "<leader>'",
        "<cmd>Pick marks<CR>",
        desc = "Open Marks Picker",
      },
      {
        '<leader>"',
        "<cmd>Pick registers<CR>",
        desc = "Open Registers Picker",
      },
      {
        "<leader>;",
        "<cmd>Pick history<CR>",
        desc = "Open Command History Picker",
      },
      {
        "<leader>:",
        "<cmd>Pick commands<CR>",
        desc = "Open Commands Picker",
      },
      {
        "<leader>,",
        "<cmd>Pick oldfiles current_dir=true<CR>",
        desc = "Open Recents Picker (cwd)",
      },
      {
        "<leader><",
        "<cmd>Pick oldfiles<CR>",
        desc = "Open Recents Picker",
      },
      { "<leader>.", "<cmd>Pick resume<CR>", desc = "Resume Picker" },
      {
        "<leader>/",
        "<cmd>Pick grep_live<CR>",
        desc = "Open Live Grep Picker",
      },
      { "<leader>?", "<cmd>Pick help<CR>", desc = "Open Help Picker" },
      { "<leader>b", pick_buffers, desc = "Open Buffers Picker" },
      {
        "<leader>d",
        "<cmd>Pick diagnostic<CR>",
        desc = "Open Diagnostics Picker",
      },
      {
        "<leader>f",
        "<cmd>Pick files<CR>",
        desc = "Open Files Picker",
      },
      {
        "<leader>gc",
        "<cmd>Pick git_commits path='%'<CR>",
        desc = "Open Buf Commits Picker",
      },
      {
        "<leader>gC",
        "<cmd>Pick git_commits<CR>",
        desc = "Open Commits Picker",
      },
      {
        "<leader>gf",
        "<cmd>Pick git_files<CR>",
        desc = "Open Files Picker",
      },
      {
        "<leader>s",
        function()
          require("mini.extra").pickers.lsp({ scope = "document_symbol" })
        end,
        desc = "Open Lsp Symbols Picker",
      },
      {
        "<leader>q",
        "<cmd>Pick list scope='quickfix'<CR>",
        desc = "Open Quickfix Picker",
      },
      {
        "<leader>Q",
        "<cmd>Pick list scope='location'<CR>",
        desc = "Open Loclist Picker",
      },
    },
    opts = {
      mappings = {
        choose_marked = "<C-y>",
        refine_marked = "<C-\\>",
      },
    },
  },
}
