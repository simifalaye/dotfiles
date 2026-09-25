local lazy = require("utils.lazy")

--
-- Now
--

lazy.now(function()
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
  lazy.later(icons.mock_nvim_web_devicons)
  lazy.later(icons.tweak_lsp_kind)
end)

--
-- Later
--

lazy.later(function()
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

-- lazy.now_if_args(function()
--   vim.pack.add({
--     {
--       src = "https://github.com/nvim-mini/mini.completion",
--       version = "stable",
--     },
--   })
--
--   local completion = require("mini.completion")
--   -- Don't show 'Text' suggestions
--   local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
--   local process_items = function(items, base)
--     return completion.default_process_items(items, base, process_items_opts)
--   end
--   completion.setup({
--     window = {
--       info = {
--         border = { " ", " ", " ", " ", " ", " ", " ", " " },
--       },
--       signature = {
--         border = { " ", " ", " ", " ", " ", " ", " ", " " },
--       },
--     },
--     lsp_completion = {
--       source_func = "omnifunc",
--       auto_setup = false,
--       process_items = process_items,
--     },
--     mappings = {
--       scroll_down = "<C-Down>",
--       scroll_up = "<C-Up>",
--     },
--   })
--
--   -- Set up LSP part of completion
--   local augroup =
--     vim.api.nvim_create_augroup("user.plugin.mini-completion", { clear = false })
--   vim.api.nvim_create_autocmd("LspAttach", {
--     desc = "Setup mini completion omnifunc",
--     group = augroup,
--     pattern = "*",
--     callback = function(args)
--       vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
--     end,
--   })
--   -- vim.lsp.on_type_formatting.enable()
--   -- vim.o.autocomplete = true
--   vim.api.nvim_create_autocmd("BufEnter", {
--     callback = function(args)
--       if
--         args.buf
--         and vim.api.nvim_buf_is_valid(args.buf)
--         and vim.bo[args.buf].buftype == "prompt"
--       then
--         vim.b.minicompletion_disable = true
--       end
--     end,
--   })
-- end)

lazy.later(function()
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

lazy.later(function()
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
