--
-- Now
--

vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.extra",
    version = "stable",
  },
})
require("mini.extra").setup({})

exec_now(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.pick",
      version = "stable",
    },
  })

  local pick = require("mini.pick")
  local win_config = function()
    local ret = {
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      width = vim.o.columns,
      relative = "minibuffer",
      use_minibuffer = true,
    }
    return ret
  end

  local default_ui_select = vim.ui.select

  -- Setup plugin with minibuffer window configuration
  pick.setup({
    window = { config = win_config },
  })

  -- NOTE: mini-pick's setup forces itself as the default `ui_select` function.
  -- You will need to save the old one before and restore it after `setup()` if you wish to use the default minibuffer `ui_select`.
  vim.ui.select = default_ui_select

  -- Set highlights to match command window
  pcall(vim.api.nvim_set_hl, 0, "MiniPickBorder", { link = "Normal" })
  pcall(vim.api.nvim_set_hl, 0, "MiniPickBorderBusy", { link = "Normal" })
  pcall(vim.api.nvim_set_hl, 0, "MiniPickNormal", { link = "Normal" })
  pcall(vim.api.nvim_set_hl, 0, "MiniPickHeader", { link = "Normal" })
end)

exec_now(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.icons",
      version = "stable",
    },
  })

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
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.notify",
      version = "stable",
    },
  })

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

--
-- Later
--

exec_later(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.bufremove",
      version = "stable",
    },
  })

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
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.hipatterns",
      version = "stable",
    },
  })

  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
    },
  })
end)

exec_later(function()
  vim.pack.add({
    {
      src = "https://github.com/nvim-mini/mini.pairs",
      version = "stable",
    },
  })

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
