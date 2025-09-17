MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-mini/mini.pick",
    checkout = "stable",
    depends = { { source = "nvim-mini/mini.extra", checkout = "stable" } },
  })

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

  -- Replace UI select
  vim.ui.select = minipick.ui_select

  -- Keymaps: Leader
  vim.keymap.set(
    "n",
    "<leader>*",
    "<cmd>Pick grep pattern='<cword>'<CR>",
    { desc = "Grep word under cursor" }
  )
  vim.keymap.set(
    "n",
    "<leader>-",
    "<cmd>Pick buf_lines scope='current'<CR>",
    { desc = "Find lines in current buffer" }
  )
  vim.keymap.set(
    "n",
    "<leader>_",
    "<cmd>Pick buf_lines<CR>",
    { desc = "Find lines in open buffers" }
  )
  vim.keymap.set(
    "n",
    "<leader>;",
    "<cmd>Pick history scope=':'<CR>",
    { desc = "Find command history" }
  )
  vim.keymap.set("n", "<leader>:", "<cmd>Pick commands<CR>", { desc = "Find command" })
  vim.keymap.set("n", "<leader>'", "<cmd>Pick marks<CR>", { desc = "Find mark" })
  vim.keymap.set("n", '<leader>"', "<cmd>Pick registers<CR>", { desc = "Find register" })
  vim.keymap.set("n", "<leader><CR>", "<cmd>Pick resume<CR>", { desc = "Resume Picker" })
  vim.keymap.set("n", "<leader>,", pick_buffers, { desc = "Find buffer" })
  vim.keymap.set("n", "<leader>.", "<cmd>Pick files<CR>", { desc = "Find file" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<CR>", { desc = "Find text" })
  vim.keymap.set(
    "n",
    "<leader>?",
    "<cmd>Pick history scope='/'<CR>",
    { desc = "Find search history" }
  )
  vim.keymap.set(
    "n",
    "<leader>d",
    "<cmd>Pick diagnostic scope='current'<CR>",
    { desc = "Find Diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>D",
    "<cmd>Pick diagnostic<CR>",
    { desc = "Find Diagnostic (workspace)" }
  )
  vim.keymap.set(
    "n",
    "<leader>s",
    "<cmd>Pick lsp scope='document_symbol'<CR>",
    { desc = "Find Symbol" }
  )
  vim.keymap.set(
    "n",
    "<leader>S",
    "<cmd>Pick lsp scope='workspace_symbol'<CR>",
    { desc = "Find Symbol (workspace)" }
  )

  -- Keymaps: Leader + b (buffer)
  vim.keymap.set("n", "<leader>bf", pick_buffers, { desc = "Find" })

  -- Keymaps: Leader + f (file)
  vim.keymap.set(
    "n",
    "<leader>fc",
    "<cmd>Pick files scope='~/.dotfiles'<CR>",
    { desc = "Find config" }
  )
  vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<CR>", { desc = "Find" })
  vim.keymap.set(
    "n",
    "<leader>fo",
    "<cmd>Pick oldfiles current_dir=true<CR>",
    { desc = "Find oldfile" }
  )
  vim.keymap.set(
    "n",
    "<leader>fO",
    "<cmd>Pick oldfiles<CR>",
    { desc = "Find oldfile (all)" }
  )

  -- Keymaps: Leader + g (git)
  vim.keymap.set("n", "<leader>gf", "<cmd>Pick git_files<CR>", { desc = "Find file" })

  -- Keymaps: Leader + s (search)
  vim.keymap.set(
    "n",
    "<leader>sc",
    "<cmd>Pick list scope='change'<CR>",
    { desc = "Change" }
  )
  vim.keymap.set(
    "n",
    "<leader>sd",
    "<cmd>Pick diagnostic scope='current'<CR>",
    { desc = "Diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>sD",
    "<cmd>Pick diagnostic<CR>",
    { desc = "Diagnostic (workspace)" }
  )
  vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep<CR>", { desc = "Grep" })
  vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<CR>", { desc = "Help tag" })
  vim.keymap.set(
    "n",
    "<leader>sH",
    "<cmd>Pick hl_groups<CR>",
    { desc = "Highlight group" }
  )
  vim.keymap.set("n", "<leader>sj", "<cmd>Pick list scope='jump'<CR>", { desc = "Jump" })
  vim.keymap.set("n", "<leader>sk", "<cmd>Pick keymaps<CR>", { desc = "Keymap" })
  vim.keymap.set(
    "n",
    "<leader>sl",
    "<cmd>Pick list scope='location'<CR>",
    { desc = "Loclist" }
  )
  vim.keymap.set("n", "<leader>so", "<cmd>Pick options<CR>", { desc = "Option" })
  vim.keymap.set(
    "n",
    "<leader>sq",
    "<cmd>Pick list scope='quickfix'<CR>",
    { desc = "Quickfix" }
  )
  vim.keymap.set(
    "n",
    "<leader>ss",
    "<cmd>Pick lsp scope='document_symbol'<CR>",
    { desc = "Symbol" }
  )
  vim.keymap.set(
    "n",
    "<leader>sS",
    "<cmd>Pick lsp scope='workspace_symbol'<CR>",
    { desc = "Symbol (workspace)" }
  )
  vim.keymap.set("n", "<leader>sz", "<cmd>Pick spellsuggest<CR>", { desc = "Spelling" })
end)
