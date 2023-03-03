return {
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = function()
      local gs = require("gitsigns")

      -- Setup plugin
      gs.setup({
        yadm = {
          enable = true,
        },
      })

      -- Setup keybinds
      local m = require("utils.map")
      m.group("<leader>h", "+hunk")
      m.noremap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "In hunk")
      m.nnoremap("]h", function()
        if vim.wo.diff then
          return "]h"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, "Next hunk", { expr = true })
      m.nnoremap("[h", function()
        if vim.wo.diff then
          return "[h"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, "Prev hunk", { expr = true })
      m.noremap({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "stage")
      m.noremap({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "reset")
      m.nnoremap("<leader>hS", gs.stage_buffer, "stage buff")
      m.nnoremap("<leader>hu", gs.undo_stage_hunk, "undo stage")
      m.nnoremap("<leader>hR", gs.reset_buffer, "reset buff")
      m.nnoremap("<leader>hp", gs.preview_hunk, "preview hunk")
      m.nnoremap("<leader>hb", function()
        gs.blame_line({ full = true })
      end, "blame line")
      m.nnoremap("<leader>hB", gs.toggle_current_line_blame, "toggle blame")
      m.nnoremap("<leader>hd", gs.diffthis, "diff index")
      m.nnoremap("<leader>hD", function()
        gs.diffthis("~")
      end, "diff head")
    end,
  },
}
