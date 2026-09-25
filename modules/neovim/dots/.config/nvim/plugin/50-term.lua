local lazy = require("utils.lazy")

lazy.now_if_args(function()
  -- Commands
  vim.api.nvim_create_user_command("TermRename", function(opts)
    if vim.bo.buftype ~= "terminal" then
      vim.notify("Not a terminal buffer!", vim.log.levels.WARN)
      return
    end
    local bufnr = 0
    local current = vim.api.nvim_buf_get_name(bufnr)
    local base = current:match("^(term://.-)|[^|]*$") or current
    vim.api.nvim_buf_set_name(bufnr, base .. "|" .. opts.args)
  end, { nargs = 1 })

  -- Autocmds
  local augroup = vim.api.nvim_create_augroup("user.plugin.term", { clear = true })
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    desc = "Setup terminal behavior on enter",
    group = augroup,
    pattern = "term://*",
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "terminal" then
        return
      end

      vim.schedule(function()
        if args.buf == vim.api.nvim_get_current_buf() then
          -- Start insert only inside of terminal buffer
          vim.cmd("startinsert")
        end
      end)
      -- Setup keymaps
      if args.buf then
        vim.keymap.set(
          "n",
          "<localleader>r",
          ":TermRename ",
          { desc = "Rename terminal", buf = args.buf }
        )
      end
    end,
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>[", "<cmd>term<CR>", { desc = "Open terminal in cwd" })
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-\\><C-[>", "<Esc>", { desc = "Send escape to terminal" })
end)
