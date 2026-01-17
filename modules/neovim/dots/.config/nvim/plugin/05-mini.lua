local deps = require("mini.deps")
local now, later = deps.now, deps.later
-- local now_if_args = deps.now_if_args

now(function()
  local icons = require("mini.icons")
  icons.setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm"
        and suf3 ~= "txt"
        and suf3 ~= "yml"
        and suf4 ~= "json"
        and suf4 ~= "yaml"
    end,
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  })
  later(icons.mock_nvim_web_devicons)
  later(icons.tweak_lsp_kind)
end)

now(function()
  local notify = require("mini.notify")
  local predicate = function(notif)
    if
      not (notif.data.source == "lsp_progress" and notif.data.client_name == "lua_ls")
    then
      return true
    end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find("Diagnosing") == nil
      and notif.msg:find("semantic tokens") == nil
  end
  local custom_sort = function(notif_arr)
    return notify.default_sort(vim.tbl_filter(predicate, notif_arr))
  end

  notify.setup({ content = { sort = custom_sort } })
end)

now(function()
  local statusline = require("mini.statusline")
  statusline.setup({
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 1000 })
        local git = statusline.section_git({ trunc_width = 40 })
        -- local diff = statusline.section_diff({ trunc_width = 75 })
        -- local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
        local lsp = statusline.section_lsp({ trunc_width = 75 })
        local filename = statusline.section_filename({ trunc_width = 140 })
        local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
        local location = statusline.section_location({ trunc_width = 75 })
        local search = statusline.section_searchcount({ trunc_width = 75 })

        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, lsp } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
    },
  })
end)

later(function()
  require("mini.extra").setup()
end)

later(function()
  require("mini.align").setup()
end)

-- later(function() require('mini.animate').setup({ scroll = { enable = false } }) end)

later(function()
  local bufremove = require("mini.bufremove")
  bufremove.setup()

  vim.keymap.set("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bD", function()
    bufremove.delete(0, true)
  end, { desc = "Delete!" })
  vim.keymap.set("n", "<leader>bw", bufremove.delete, { desc = "Wipeout" })
  vim.keymap.set("n", "<leader>bW", function()
    bufremove.wipeout(0, true)
  end, { desc = "Wipeout!" })
end)

later(function()
  local clue = require("mini.clue")
  clue.setup({
    clues = {
      { mode = { "n", "v" }, keys = "gr", desc = "+Lsp" },
      { mode = { "n", "v" }, keys = "grw", desc = "+Workspace" },
      { mode = { "n", "v" }, keys = "<localleader>", desc = "+Local" },
      { mode = { "n", "v" }, keys = "<leader>", desc = "+Global" },
      { mode = { "n", "v" }, keys = "<leader><tab>", desc = "+Tab" },
      { mode = { "n", "v" }, keys = "<leader>b", desc = "+Buffer" },
      { mode = { "n", "v" }, keys = "<leader>f", desc = "+File" },
      { mode = { "n", "v" }, keys = "<leader>g", desc = "+Git" },
      { mode = { "n", "v" }, keys = "<leader>u", desc = "+UI" },
      { mode = { "n", "v" }, keys = "<leader>q", desc = "+Quit/Session" },
      { mode = { "n", "v" }, keys = "<leader>w", desc = "+Window" },
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
    triggers = {
      { mode = { "n", "x" }, keys = "<localleader>" }, -- Leader triggers
      { mode = { "n", "x" }, keys = "<leader>" }, -- Leader triggers
      { mode = "n", keys = "\\" }, -- mini.basics
      { mode = { "n", "x" }, keys = "[" },
      { mode = { "n", "x" }, keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- Built-in completion
      { mode = { "n", "x" }, keys = "g" }, -- `g` key
      { mode = { "n", "x" }, keys = "'" }, -- Marks
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' }, -- Registers
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" }, -- Window commands
      { mode = { "n", "x" }, keys = "s" }, -- `s` key
      { mode = { "n", "x" }, keys = "z" }, -- `z` key
    },
  })
end)

later(function()
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "│",
  })
end)

later(function()
  require("mini.move").setup({ options = { reindent_linewise = false } })
end)

later(function()
  require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
  })
end)

later(function()
  require("mini.surround").setup()
end)

later(function()
  local pick = require("mini.pick")

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
    local show = pick.config.source.show
      or function(buf_id, items_, query)
        pick.default_show(buf_id, items_, query, { show_icons = true })
      end
    local default_opts = { source = { name = "Buffers", show = show } }
    opts = vim.tbl_deep_extend(
      "force",
      default_opts,
      opts or {},
      { source = { items = items } }
    )
    return pick.start(opts)
  end

  -- Load plugin
  pick.setup({
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
  vim.ui.select = pick.ui_select

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

  if vim.fn.has("nvim-0.12") == 1 then
    local pick_mb = require("minibuffer.integrations.mini-pick")
    pick.is_picker_active = pick_mb.is_picker_active
    pick.set_picker_items = pick_mb.set_picker_items
    pick.start = pick_mb.start
  end
end)
