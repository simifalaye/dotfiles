local M = {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  cmd = { "Gitsigns" },
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "Next Git Hunk" })
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "Prev Git Hunk" })
      map("n", "]H", function()
        gitsigns.nav_hunk("last")
      end, { desc = "Last Git Hunk" })
      map("n", "[H", function()
        gitsigns.nav_hunk("first")
      end, { desc = "First Git Hunk" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "In Hunk" })

      -- Actions
      map("n", "<leader>ghb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame" })
      map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Diff" })
      map("n", "<leader>ghD", function()
        gitsigns.diffthis("~")
      end, { desc = "Diff HEAD" })
      map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
      map("v", "<leader>ghr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Hunk" })
      map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
      map("v", "<leader>ghs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Hunk" })
      map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    end,
  },
}

M.init = function()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>g", group = "+git" } })
    wk.add({ { "<leader>gh", group = "+hunk" } })
  end
end

return M
