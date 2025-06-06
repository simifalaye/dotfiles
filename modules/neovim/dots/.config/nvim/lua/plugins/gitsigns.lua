local M = {
  "lewis6991/gitsigns.nvim",
}

M.cmd = { "Gitsigns" }

M.event = { "BufReadPost", "BufNewFile", "BufWritePre" }

M.opts = {
  preview_config = {
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  signs_staged_enable = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 100,
  },
}

M.config = function()
  local gitsigns = require("gitsigns")

  -- Navigation
  vim.keymap.set("n", "]g", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gitsigns.nav_hunk("next")
    end
  end, { desc = "Next Git Hunk" })
  vim.keymap.set("n", "[g", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gitsigns.nav_hunk("prev")
    end
  end, { desc = "Prev Git Hunk" })
  vim.keymap.set("n", "]G", function()
    gitsigns.nav_hunk("last")
  end, { desc = "Last Git Hunk" })
  vim.keymap.set("n", "[G", function()
    gitsigns.nav_hunk("first")
  end, { desc = "First Git Hunk" })

  -- Text object
  vim.keymap.set(
    { "o", "x" },
    "ig",
    ":<C-U>Gitsigns select_hunk<CR>",
    { desc = "In Hunk" }
  )
  vim.keymap.set(
    { "o", "x" },
    "ag",
    ":<C-u>Gitsigns select_hunk<CR>",
    { silent = true, desc = "A hunk" }
  )

  -- Actions
  vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
  vim.keymap.set(
    "n",
    "<leader>gP",
    gitsigns.preview_hunk_inline,
    { desc = "Preview Hunk Inline" }
  )
  vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
  vim.keymap.set("v", "<leader>gr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset Hunk" })
  vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
  vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
  vim.keymap.set("v", "<leader>gs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage Hunk" })
  vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
end

return M
