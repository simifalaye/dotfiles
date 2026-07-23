exec_now(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.nvim",
      version = "stable",
    },
  })
end)

--
-- Now
--

exec_now(function()
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
  exec_later(icons.mock_nvim_web_devicons)
  exec_later(icons.tweak_lsp_kind)
end)

exec_now(function()
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

  -- Disable default progress messages in cmdline and only use notification
  vim.lsp.handlers["$/progress"] = function() end

  notify.setup({
    content = { sort = custom_sort },
    window = {
      config = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    },
  })

  -- Override vim.notify with log level aware function
  local default_vim_notify = notify.make_notify()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(msg, level, opts)
    level = level or vim.log.levels.INFO
    if level < vim.g.user_log_level then
      return
    end
    return default_vim_notify(msg, level, opts)
  end

  -- Setup keymaps
  vim.keymap.set("n", "g{", function()
    require("mini.notify").show_history()
  end, { desc = "Show notification history" })
  vim.keymap.set("n", "g}", function()
    require("mini.notify").clear()
  end, { desc = "Clear notifications" })
  vim.keymap.set("n", "<leader>un", function()
    if vim.g.mininotify_disable then
      vim.g.mininotify_disable = false
    else
      vim.g.mininotify_disable = true
    end
    local state = vim.g.mininotify_disable
    vim.notify(string.format("notifications %s", require("utils.ui").bool2str(not state)))
  end, { desc = "Toggle notifications" })
end)

exec_now_if_args(function()
  local completion = require("mini.completion")
  -- Don't show 'Text' suggestions
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return completion.default_process_items(items, base, process_items_opts)
  end
  completion.setup({
    window = {
      info = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
      signature = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    },
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = process_items,
    },
    mappings = {
      scroll_down = "<C-Down>",
      scroll_up = "<C-Up>",
    },
  })

  -- Set up LSP part of completion
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Setup mini completion omnifunc",
    group = custom_config_augroup,
    pattern = "*",
    callback = function(args)
      vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end,
  })
  -- vim.lsp.on_type_formatting.enable()
  -- vim.o.autocomplete = true
end)

--
-- Later
--

exec_later(function()
  require("mini.extra").setup()
end)

exec_later(function()
  require("mini.align").setup()
end)

exec_later(function()
  local bufremove = require("mini.bufremove")
  bufremove.setup({})

  vim.keymap.set("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bD", function()
    bufremove.delete(0, true)
  end, { desc = "Delete!" })
  vim.keymap.set("n", "<leader>bw", bufremove.delete, { desc = "Wipeout" })
  vim.keymap.set("n", "<leader>bW", function()
    bufremove.wipeout(0, true)
  end, { desc = "Wipeout!" })
end)

exec_later(function()
  require("mini.cmdline").setup({
    autopeek = {
      enable = true,
      window = {
        config = {
          border = { " ", " ", " ", " ", " ", " ", " ", " " },
        },
      },
    },
  })
end)

exec_later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = require("mini.extra").gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE" }, "MiniHipatternsNote"),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

exec_later(function()
  local keymap = require("mini.keymap")
  require("mini.keymap").setup({})

  -- Completion/pairs improvements
  keymap.map_multistep("i", "<Tab>", { "pmenu_next" })
  keymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
  keymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  keymap.map_multistep("i", "<BS>", { "minipairs_bs" })

  -- local map_combo = keymap.map_combo
  -- -- Support most common modes. This can also contain 't', but would
  -- -- only mean to press `<Esc>` inside terminal.
  -- local mode = { "i", "c", "x", "s" }
  -- map_combo(mode, "jk", "<BS><BS><Esc>")
  -- -- To not have to worry about the order of keys, also map "kj"
  -- map_combo(mode, "kj", "<BS><BS><Esc>")
  -- -- Escape into Normal mode from Terminal mode
  -- map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
  -- map_combo("t", "kj", "<BS><BS><C-\\><C-n>")
end)

exec_later(function()
  require("mini.cursorword").setup()
end)

exec_later(function()
  local diff = require("mini.diff")
  diff.setup({
    view = {
      style = "sign",
      signs = {
        add = "┃",
        change = "┃",
        delete = "▁",
      },
    },
  })
  vim.keymap.set("n", "gh.", diff.toggle_overlay, { desc = "Toggle hunk overlay" })
end)

exec_later(function()
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
    symbol = "╎",
  })
end)

exec_later(function()
  local pairs = require("mini.pairs")
  local opts = {
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  }
  pairs.setup(opts)

  local open = pairs.open
  ---@diagnostic disable-next-line: duplicate-set-field
  pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= "" then
      return open(pair, neigh_pattern)
    end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])
    if
      opts.markdown
      and o == "`"
      and vim.bo.filetype == "markdown"
      and before:match("^%s*``")
    then
      return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
    end
    if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
      return o
    end
    if opts.skip_ts and #opts.skip_ts > 0 then
      local ok, captures = pcall(
        vim.treesitter.get_captures_at_pos,
        0,
        cursor[1] - 1,
        math.max(cursor[2] - 1, 0)
      )
      for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(opts.skip_ts, capture.capture) then
          return o
        end
      end
    end
    if opts.skip_unbalanced and next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
      if count_close > count_open then
        return o
      end
    end
    return open(pair, neigh_pattern)
  end
end)

exec_later(function()
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

  local win_config = function()
    return {
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      height = 15,
      width = vim.o.columns,
    }
  end

  -- Load plugin
  require("mini.extra").setup({})
  pick.setup({
    options = { use_cache = true },
    mappings = {
      choose_marked = "<C-y>",
      refine_marked = "<C-\\>",
    },
    window = { config = win_config },
  })

  -- Replace UI select
  vim.ui.select = pick.ui_select

  -- Keymaps: Leader
  vim.keymap.set("n", "<leader><CR>", "<cmd>Pick resume<CR>", { desc = "Resume Picker" })
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
  vim.keymap.set("n", "<leader>,", pick_buffers, { desc = "Find buffer" })
  vim.keymap.set("n", "<leader>.", "<cmd>Pick files<CR>", { desc = "Find file" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<CR>", { desc = "Find text" })
  vim.keymap.set(
    "n",
    "<leader>?",
    "cmd>Pick history scope='/'<CR>",
    { desc = "Find search history" }
  )

  -- Keymaps: Leader + b (buffer)
  vim.keymap.set("n", "<leader>bf", pick_buffers, { desc = "Find" })

  -- <leader> + c
  vim.keymap.set(
    "n",
    "<leader>cd",
    "<cmd>Pick diagnostic scope='current'<CR>",
    { desc = "Diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>cD",
    "<cmd>Pick diagnostic<CR>",

    { desc = "Diagnostic (workspace)" }
  )
  vim.keymap.set(
    "n",
    "<leader>cl",
    "<cmd>Pick list scope='location'<CR>",
    { desc = "Loclist" }
  )
  vim.keymap.set(
    "n",
    "<leader>cq",
    "<cmd>Pick list scope='quickfix'<CR>",
    { desc = "Quickfix" }
  )
  vim.keymap.set(
    "n",
    "<leader>cs",
    "<cmd>Pick lsp scope='document_symbol'<CR>",
    { desc = "Symbol" }
  )
  vim.keymap.set(
    "n",
    "<leader>cS",
    "<cmd>Pick lsp scope='workspace_symbol'<CR>",
    { desc = "Symbol (workspace)" }
  )

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

  -- Keymaps: Leader + h (help)
  vim.keymap.set(
    "n",
    "<leader>hc",
    "<cmd>Pick colorschemes<CR>",
    { desc = "Colorschemes" }
  )
  vim.keymap.set("n", "<leader>hh", "<cmd>Pick help<CR>", { desc = "Help tag" })
  vim.keymap.set(
    "n",
    "<leader>hH",
    "<cmd>Pick hl_groups<CR>",
    { desc = "Highlight group" }
  )
  vim.keymap.set("n", "<leader>hk", "<cmd>Pick keymaps<CR>", { desc = "Keymap" })
  vim.keymap.set("n", "<leader>hm", "<cmd>Pick manpages<CR>", { desc = "Manpages" })
  vim.keymap.set("n", "<leader>ho", "<cmd>Pick options<CR>", { desc = "Option" })
end)

exec_later(function()
  local snippets, config_path = require("mini.snippets"), vim.fn.stdpath("config")
  local latex_patterns = { "latex/**/*.json", "**/latex.json" }
  local lang_patterns = {
    tex = latex_patterns,
    plaintex = latex_patterns,
    -- Recognize special injected language of markdown tree-sitter parser
    markdown_inline = { "markdown.json" },
  }
  local gen_loader = require("mini.snippets").gen_loader
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(vim.fs.joinpath(config_path, "snippets", "all.json")),
      gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
  })
  snippets.start_lsp_server()
end)

exec_later(function()
  require("mini.surround").setup({})
end)
