local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end

local lz = require("utils.lazy").new("gitsigns", function()
  local gitsigns = require("gitsigns")
  gitsigns.setup({
    on_attach = function(bufnr)
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

      -- Actions
      map("n", "<leader>gb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame line" })
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

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "In Hunk" })
    end,
  })
  return true
end)
lz:cmds({ "GitSigns" })

local load_autocmd_id = 0
load_autocmd_id = vim.api.nvim_create_autocmd({ "BufRead" }, {
  desc = "Load gitsigns plugin",
  callback = function()
    vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
    if vim.v.shell_error == 0 then
      lz:load()
      -- Delete autocmd
      if load_autocmd_id ~= 0 then
        vim.api.nvim_del_autocmd(load_autocmd_id)
      end
    end
  end,
})
