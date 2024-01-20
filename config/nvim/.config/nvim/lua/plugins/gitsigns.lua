local gitsigns = require("utils.lib").reqcall("gitsigns") ---@module 'gitsigns'

return {
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Gitsigns" },
    ft = { "gitcommit", "diff" },
    keys = {
      {
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        desc = "In Hunk",
      },
      { "]h", gitsigns.next_hunk, desc = "Next Git Hunk" },
      { "[h", gitsigns.prev_hunk, desc = "Prev Git Hunk" },
      { "<leader>g", "<leader>g", desc = "+git" },
      { "<leader>gb", gitsigns.blame_line, { full = true }, desc = "Blame Line" },
      { "<leader>gd", gitsigns.diffthis, desc = "Diff" },
      {
        "<leader>gD",
        function()
          gitsigns.diffthis("~")
        end,
        desc = "Diff HEAD",
      },
      { "<leader>gp", gitsigns.preview_hunk, desc = "Preview Hunk" },
      { "<leader>gr", gitsigns.reset_hunk, desc = "Reset Hunk" },
      { "<leader>gR", gitsigns.reset_buffer, desc = "Reset Buff" },
      { "<leader>gu", gitsigns.undo_stage_hunk, desc = "Undo Stage" },
      { "<leader>gs", gitsigns.stage_hunk, desc = "Stage Hunk" },
      { "<leader>gS", gitsigns.stage_buffer, desc = "Stage Buff" },
    },
    init = function()
      -- Load gitsigns only when a git file is opened
      local id = 0
      id = vim.api.nvim_create_autocmd("BufRead", {
        desc = "Lazy load gitsigns",
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            -- Delete autocmd
            vim.api.nvim_del_autocmd(id)
            -- Load plugin
            vim.schedule(function()
              require("lazy").load({ plugins = { "gitsigns.nvim" } })
            end)
          end
        end,
      })
    end,
    opts = {},
  },
}
