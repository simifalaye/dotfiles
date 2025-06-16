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

local M = { "echasnovski/mini.pick", version = "*" }

M.dependencies = {
  { "echasnovski/mini.extra", version = "*", config = true },
}

M.commands = { "Pick" }

M.keys = {
  -- <leader>
  {
    "<leader>*",
    "<cmd>Pick grep pattern='<cword>'<CR>",
    desc = "Grep word under cursor",
  },
  {
    "<leader>#",
    "<cmd>Pick grep pattern='<cword>'<CR>",
    desc = "Grep word under cursor",
  },
  {
    "<leader>-",
    "<cmd>Pick buf_lines scope='current'<CR>",
    desc = "Find lines in buffer",
  },
  { "<leader>_", "<cmd>Pick buf_lines<CR>", desc = "Find lines all buffers" },
  { "<leader>[", "<cmd>Pick oldfiles current_dir=true<CR>", desc = "Find oldfiles" },
  { "<leader>{", "<cmd>Pick oldfiles<CR>", desc = "Find oldfiles (all)" },
  { "<leader>]", "<cmd>Pick grep_live<CR>", desc = "Live grep" },
  { "<leader>;", "<cmd>Pick history scope=':'<CR>", desc = "Find command history" },
  { "<leader>:", "<cmd>Pick commands<CR>", desc = "Find commands" },
  { "<leader>'", "<cmd>Pick marks<CR>", desc = "Find marks" },
  { '<leader>"', "<cmd>Pick registers<CR>", desc = "Find registers" },
  { "<leader><CR>", "<cmd>Pick resume<CR>", desc = "Resume last find" },
  { "<leader>,", pick_buffers, desc = "Find buffers" },
  { "<leader>.", "<cmd>Pick files<CR>", desc = "Find files" },
  { "<leader>/", "<cmd>Pick history scope='/'<CR>", desc = "Find search history" },
  { "<leader>?", "<cmd>Pick help<CR>", desc = "Find help tags" },
  -- <leader> + f
  { "<leader>fc", "<cmd>Pick list scope='change'<CR>", desc = "Changes" },
  { "<leader>fC", "<cmd>Pick<CR>", desc = "Colorschemes" },
  { "<leader>fd", "<cmd>Pick diagnostic scope='current'<CR>", desc = "Diagnostics" },
  { "<leader>fD", "<cmd>Pick diagnostic<CR>", desc = "Diagnostics (workspace)" },
  { "<leader>ff", "<cmd>Pick git_files<CR>", desc = "Files (git)" },
  { "<leader>fg", "<cmd>Pick grep<CR>", desc = "Grep" },
  { "<leader>fh", "<cmd>Pick hl_groups<CR>", desc = "Highlight groups" },
  { "<leader>fj", "<cmd>Pick list scope='jump'<CR>", desc = "Jumps" },
  { "<leader>fk", "<cmd>Pick keymaps<CR>", desc = "Keymaps" },
  { "<leader>fl", "<cmd>Pick list scope='location'<CR>", desc = "Loclist" },
  { "<leader>fo", "<cmd>Pick options<CR>", desc = "Options" },
  { "<leader>fq", "<cmd>Pick list scope='quickfix'<CR>", desc = "Quickfix" },
  { "<leader>fs", "<cmd>Pick lsp scope='document_symbol'<CR>", desc = "Symbols" },
  {
    "<leader>fS",
    "<cmd>Pick lsp scope='workspace_symbol'<CR>",
    desc = "Symbols (workspace)",
  },
  { "<leader>fz", "<cmd>Pick spellsuggest<CR>", desc = "Spelling" },
}

M.opts = {
  mappings = {
    choose_marked = "<C-y>",
    refine_marked = "<C-\\>",
  },
}

return M
