MiniDeps.add({
  source = "lewis6991/gitsigns.nvim",
})

MiniDeps.later(function()
  -- Load plugin
  local gitsigns = require("gitsigns")
  gitsigns.setup({
    preview_config = {
      border = "solid",
      style = "minimal",
    },
    signs_staged_enable = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 100,
    },
  })

  -- Keymaps
  vim.keymap.set({ "n", "x" }, "[g", function()
    gitsigns.nav_hunk("prev")
  end, { desc = "Go to previous git hunk" })
  vim.keymap.set({ "n", "x" }, "]g", function()
    gitsigns.nav_hunk("next")
  end, { desc = "Go to next git hunk" })
  vim.keymap.set({ "n", "x" }, "[G", function()
    gitsigns.nav_hunk("first")
  end, { desc = "Go to first git hunk" })
  vim.keymap.set({ "n", "x" }, "]G", function()
    gitsigns.nav_hunk("last")
  end, { desc = "Go to last git hunk" })
  vim.keymap.set(
    { "o", "x" },
    "ig",
    ":<C-U>Gitsigns select_hunk<CR>",
    { desc = "inner git hunk" }
  )
  vim.keymap.set(
    { "o", "x" },
    "ag",
    ":<C-u>Gitsigns select_hunk<CR>",
    { silent = true, desc = "git hunk" }
  )
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

  -- Auto-refresh fugitive buffers on staging/unstaging hunks
  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsChanged",
    desc = "Automatically refresh fugitive buffers on staging/unstaging hunks.",
    group = vim.api.nvim_create_augroup("GitsignsFugitiveIntegration", {}),
    callback = function(args)
      local file = args.data.file ---@type string
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Only update fugitive buffers that matches the updated file
        if
          vim.bo[buf].ft == "fugitive"
          and require("utils.fs").contains(
            vim.fn.fnamemodify(
              vim.api.nvim_buf_get_name(buf):match("fugitive://(.*)"),
              ":h:h"
            ),
            file
          )
        then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_call(buf, vim.cmd.edit)
            end
          end)
          break
        end
      end
    end,
  })
end)
