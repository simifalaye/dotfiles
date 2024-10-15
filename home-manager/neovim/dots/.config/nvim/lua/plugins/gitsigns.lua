local lz = require("utils.lazy").new("gitsigns", function()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "gh", group = "+git-hunk" } })
  end

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
      map("n", "]H", function()
        gitsigns.nav_hunk("last")
      end, { desc = "Last Git Hunk" })
      map("n", "[H", function()
        gitsigns.nav_hunk("first")
      end, { desc = "First Git Hunk" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "In Hunk" })

      -- Actions
      map("n", "ghb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame" })
      map("n", "ghd", gitsigns.diffthis, { desc = "Diff" })
      map("n", "ghD", function()
        gitsigns.diffthis("~")
      end, { desc = "Diff HEAD" })
      map("n", "ghp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
      map("n", "ghr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
      map("v", "ghr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Hunk" })
      map("n", "ghR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
      map("n", "ghs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
      map("v", "ghs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Hunk" })
      map("n", "ghS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
      map("n", "ghu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    end,
  })
  return true
end)
lz:cmds({ "GitSigns" })

local load_autocmd_id = 0
load_autocmd_id = vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = vim.api.nvim_create_augroup("user_lazy_gitsigns", {}),
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
