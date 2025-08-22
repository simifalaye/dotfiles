MiniDeps.add({
  source = "echasnovski/mini.pick",
  checkout = "stable",
  depends = { { source = "echasnovski/mini.extra", checkout = "stable" } },
})

MiniDeps.later(function()
  local minipick = require("mini.pick")

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
    local show = minipick.config.source.show
      or function(buf_id, items_, query)
        minipick.default_show(buf_id, items_, query, { show_icons = true })
      end
    local default_opts = { source = { name = "Buffers", show = show } }
    opts = vim.tbl_deep_extend(
      "force",
      default_opts,
      opts or {},
      { source = { items = items } }
    )
    return minipick.start(opts)
  end

  -- Load plugin
  require("mini.extra").setup({})
  minipick.setup({
    options = { use_cache = true },
    mappings = {
      choose_marked = "<C-y>",
      refine_marked = "<C-\\>",
    },
    window = {
      config = function()
        return {
          width = vim.o.columns,
        }
      end,
    },
  })

  -- Set keymaps
  vim.keymap.set(
    "n",
    "<leader>*",
    "<cmd>Pick grep pattern='<cword>'<CR>",
    { desc = "Grep word under cursor" }
  )
  vim.keymap.set(
    "n",
    "<leader>#",
    "<cmd>Pick grep pattern='<cword>'<CR>",
    { desc = "Grep word under cursor" }
  )
  vim.keymap.set(
    "n",
    "<leader>-",
    "<cmd>Pick buf_lines scope='current'<CR>",
    { desc = "Find lines in buffer" }
  )
  vim.keymap.set(
    "n",
    "<leader>_",
    "<cmd>Pick buf_lines<CR>",
    { desc = "Find lines all buffers" }
  )
  vim.keymap.set(
    "n",
    "<leader>[",
    "<cmd>Pick oldfiles current_dir=true<CR>",
    { desc = "Find oldfiles" }
  )
  vim.keymap.set(
    "n",
    "<leader>]",
    "<cmd>Pick oldfiles<CR>",
    { desc = "Find oldfiles (all)" }
  )
  vim.keymap.set(
    "n",
    "<leader>;",
    "<cmd>Pick history scope=':'<CR>",
    { desc = "Find command history" }
  )
  vim.keymap.set("n", "<leader>:", "<cmd>Pick commands<CR>", { desc = "Find commands" })
  vim.keymap.set("n", "<leader>'", "<cmd>Pick marks<CR>", { desc = "Find marks" })
  vim.keymap.set("n", '<leader>"', "<cmd>Pick registers<CR>", { desc = "Find registers" })
  vim.keymap.set(
    "n",
    "<leader><CR>",
    "<cmd>Pick resume<CR>",
    { desc = "Resume last find" }
  )
  vim.keymap.set("n", "<leader>,", pick_buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>.", "<cmd>Pick files<CR>", { desc = "Find files" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<CR>", { desc = "Find text" })
  vim.keymap.set(
    "n",
    "<leader>?",
    "<cmd>Pick history scope='/'<CR>",
    { desc = "Find search history" }
  )
  vim.keymap.set(
    "n",
    "<leader>fc",
    "<cmd>Pick list scope='change'<CR>",
    { desc = "Changes" }
  )
  vim.keymap.set(
    "n",
    "<leader>fd",
    "<cmd>Pick diagnostic scope='current'<CR>",
    { desc = "Diagnostics" }
  )
  vim.keymap.set(
    "n",
    "<leader>fD",
    "<cmd>Pick diagnostic<CR>",
    { desc = "Diagnostics (workspace)" }
  )
  vim.keymap.set("n", "<leader>ff", "<cmd>Pick git_files<CR>", { desc = "Files (git)" })
  vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep<CR>", { desc = "Grep" })
  vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<CR>", { desc = "Help tags" })
  vim.keymap.set(
    "n",
    "<leader>fH",
    "<cmd>Pick hl_groups<CR>",
    { desc = "Highlight groups" }
  )
  vim.keymap.set("n", "<leader>fj", "<cmd>Pick list scope='jump'<CR>", { desc = "Jumps" })
  vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<CR>", { desc = "Keymaps" })
  vim.keymap.set(
    "n",
    "<leader>fl",
    "<cmd>Pick list scope='location'<CR>",
    { desc = "Loclist" }
  )
  vim.keymap.set("n", "<leader>fo", "<cmd>Pick options<CR>", { desc = "Options" })
  vim.keymap.set(
    "n",
    "<leader>fq",
    "<cmd>Pick list scope='quickfix'<CR>",
    { desc = "Quickfix" }
  )
  vim.keymap.set(
    "n",
    "<leader>fs",
    "<cmd>Pick lsp scope='document_symbol'<CR>",
    { desc = "Symbols" }
  )
  vim.keymap.set(
    "n",
    "<leader>fS",
    "<cmd>Pick lsp scope='workspace_symbol'<CR>",
    { desc = "Symbols (workspace)" }
  )
  vim.keymap.set("n", "<leader>fz", "<cmd>Pick spellsuggest<CR>", { desc = "Spelling" })
end)
