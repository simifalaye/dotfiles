exec_now(function()
  vim.pack.add({
    {
      src = "https://github.com/stevearc/resession.nvim",
    },
  })

  local resession = require("resession")
  resession.setup({
    -- Options for automatically saving sessions on a timer
    autosave = {
      enabled = false,
      -- How often to save (in seconds)
      interval = 60,
      -- Notify when autosaved
      notify = true,
    },
    -- Save and restore these options
    options = {
      "binary",
      "bufhidden",
      "buflisted",
      "cmdheight",
      "diff",
      "filetype",
      "modifiable",
      "previewwindow",
      "readonly",
      "scrollbind",
      "winfixheight",
      "winfixwidth",
    },
    buf_filter = function(bufnr)
      -- Don't save terminal buffers
      if vim.bo[bufnr].buftype == "terminal" then
        return false
      end
      return require("resession").default_buf_filter(bufnr)
    end,
    -- Custom logic for determining if a buffer should be included in a tab-scoped session
    tab_buf_filter = function(_, _)
      return true
    end,
    -- The name of the directory to store sessions in
    dir = "session",
    -- Show more detail about the sessions when selecting one to load.
    -- Disable if it causes lag.
    load_detail = true,
    -- List order ["modification_time", "creation_time", "filename"]
    load_order = "modification_time",
    -- Configuration for extensions
    extensions = {
      quickfix = {},
      compiler = {},
    },
  })

  ---@type table<string, integer[]>
  local terminals_map = {}

  local function term_anchor_name(buf)
    return "resession://terminal-anchor/" .. buf
  end

  local function get_term_anchor(buf)
    return vim.fn.bufnr(term_anchor_name(buf))
  end

  local function set_terminal_anchor(buf, win)
    local anchor = get_term_anchor(buf)
    if anchor < 0 then
      anchor = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(anchor, term_anchor_name(buf))
      dd("Created term anchor: " .. anchor)
    end
    if win and win > 0 then
      vim.api.nvim_win_set_buf(win, anchor)
    end
  end

  local function reset_term_anchor(buf)
    local anchor = get_term_anchor(buf)
    if anchor < 0 or not vim.api.nvim_buf_is_valid(anchor) then
      return
    end
    vim.api.nvim_buf_delete(anchor, { force = true })
  end

  local function cleanup_term_anchors()
    local valid_anchors = {}
    for _, terminals in pairs(terminals_map) do
      for _, term_buf in ipairs(terminals) do
        valid_anchors["resession://terminal-anchor/" .. term_buf] = true
      end
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("^resession://terminal%-anchor/") then
        if not valid_anchors[name] then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end

  -- Setup hooks
  resession.add_hook("pre_save", function()
    local current = resession.get_current()
    if not current then
      return
    end

    local terminals = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
          vim.api.nvim_buf_is_valid(buf)
          and vim.bo[buf].buftype == "terminal"
          and vim.bo[buf].buflisted
      then
        local wins = vim.fn.win_findbuf(buf)
        if #wins > 0 then
          for _, win in ipairs(wins) do
            dd("Found window " .. win .. ", for terminal buf " .. buf)
            set_terminal_anchor(buf, win)
          end
        end
        table.insert(terminals, buf)
        vim.bo[buf].buflisted = false
      end
    end
    terminals_map[current] = terminals
  end)
  resession.add_hook("post_load", function()
    cleanup_term_anchors()

    local current = resession.get_current()
    if not current or not terminals_map[current] then
      return
    end

    for _, buf in ipairs(terminals_map[current]) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.bo[buf].buflisted = true
        local anchor = get_term_anchor(buf)
        if anchor > 0 then
          dd("Anchor exists for terminal: " .. buf)
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == anchor then
              dd("Setting win term buf to win: " .. win)
              vim.api.nvim_win_set_buf(win, buf)
            end
          end
          reset_term_anchor(buf)
        end
      end
    end
    terminals_map[current] = nil
  end)

  -- Setup keymaps
  vim.keymap.set("n", "<leader>qd", resession.delete, { desc = "Delete Session" })
  vim.keymap.set("n", "<leader>ql", resession.load, { desc = "Load Session" })
  vim.keymap.set("n", "<leader>qs", resession.save, { desc = "Save Session" })
end)
