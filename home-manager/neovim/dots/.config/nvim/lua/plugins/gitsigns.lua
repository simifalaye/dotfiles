return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    cmd = { "Gitsigns" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({ { "<leader>g", group = "+git" } })
      end
    end,
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
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame" })
        map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })
        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff HEAD" })
        map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset Hunk" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage Hunk" })
        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
        map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      end,
    },
  },
}
