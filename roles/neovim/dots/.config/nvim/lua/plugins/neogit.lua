local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end

local lz = require("utils.lazy").new("neogit", function()
  require("neogit").setup({})
  vim.keymap.set(
    "n",
    "<leader>gg",
    "<cmd>Neogit kind=replace<CR>",
    { desc = "Open Neogit" }
  )
  local last_status_linenr = 0
  local grp_id = vim.api.nvim_create_augroup("user_plugin_neogit", {})
  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    desc = "Save neogit status cursor position",
    group = grp_id,
    pattern = "NeogitStatus",
    callback = function()
      last_status_linenr = vim.api.nvim_win_get_cursor(0)[1]
    end,
  })
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    desc = "Restore neogit status cursor position",
    group = grp_id,
    pattern = "NeogitStatus",
    callback = function()
      vim.defer_fn(function()
        if
          last_status_linenr > 0
          and last_status_linenr <= vim.api.nvim_buf_line_count(0)
        then
          vim.api.nvim_win_set_cursor(0, { last_status_linenr, 0 })
        end
      end, 100)
    end,
  })
  return true
end)

local load_autocmd_id = 0
load_autocmd_id = vim.api.nvim_create_autocmd({ "VimEnter", "BufRead" }, {
  desc = "Load neogit plugin",
  callback = function(ev)
    local path = ev.event == "VimEnter" and vim.fn.getcwd() or vim.fn.expand("%:p:h")
    vim.fn.system("git -C " .. '"' .. path .. '"' .. " rev-parse")
    if vim.v.shell_error == 0 then
      lz:load()
      -- Delete autocmd
      if load_autocmd_id ~= 0 then
        vim.api.nvim_del_autocmd(load_autocmd_id)
      end
    end
  end,
})
