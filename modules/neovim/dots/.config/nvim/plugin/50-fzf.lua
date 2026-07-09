if true then
  return
end

vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
  })

  -- Setup plugin
  local fzf = require("fzf-lua")
  fzf.setup({
    "ivy",
    grep = {
      rg_glob = true,
      rg_opts = table.concat({
        "--no-messages",
        "--hidden",
        "--follow",
        "--smart-case",
        "--column",
        "--line-number",
        "--no-heading",
        "--color=always",
        "-g=!.git/",
        "-e",
      }, " "),
      fzf_opts = {
        ["--info"] = "inline-right",
      },
    },
  })
  fzf.register_ui_select()

  -- Keymaps

  -- <leader>
  vim.keymap.set("n", "<leader>*", fzf.grep_cword, { desc = "Grep word under cursor" })
  vim.keymap.set("x", "<leader>*", fzf.grep_visual, { desc = "Grep visual selection" })
  vim.keymap.set("n", "<leader>#", fzf.grep_cword, { desc = "Grep word under cursor" })
  vim.keymap.set("x", "<leader>#", fzf.grep_visual, { desc = "Grep visual selection" })
  vim.keymap.set("n", "<leader>-", fzf.blines, { desc = "Find lines in buffer" })
  vim.keymap.set("x", "<leader>-", fzf.blines, { desc = "Find lines in selection" })
  vim.keymap.set("n", "<leader>\\", function()
    fzf.oldfiles({ cwd_only = true })
  end, { desc = "Find recent (cwd)" })
  vim.keymap.set("n", "<leader>;", fzf.command_history, { desc = "Find command history" })
  vim.keymap.set("n", "<leader>:", fzf.commands, { desc = "Find commands" })
  vim.keymap.set("n", "<leader>'", fzf.marks, { desc = "Find marks" })
  vim.keymap.set("n", '<leader>"', fzf.registers, { desc = "Find registers" })
  vim.keymap.set("n", "<leader><CR>", fzf.resume, { desc = "Resume last find" })
  vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>.", fzf.files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Grep" })
  vim.keymap.set("n", "<leader>?", fzf.help_tags, { desc = "Find help tags" })
  -- <leader> + b
  vim.keymap.set("n", "<leader>bf", fzf.buffers, { desc = "Find" })
  -- <leader> + c
  vim.keymap.set("n", "<leader>cd", fzf.diagnostics_document, { desc = "Diagnostics" })
  vim.keymap.set(
    "n",
    "<leader>cD",
    fzf.diagnostics_workspace,
    { desc = "Diagnostics (workspace)" }
  )
  vim.keymap.set("n", "<leader>cs", fzf.lsp_document_symbols, { desc = "Symbols" })
  vim.keymap.set(
    "n",
    "<leader>cS",
    fzf.lsp_workspace_symbols,
    { desc = "Symbols (workspace)" }
  )
  -- <leader> + f
  vim.keymap.set("n", "<leader>fc", function()
    fzf.files({ cwd = "~/.dotfiles" })
  end, { desc = "Config files" })
  vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find" })
  vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Oldfiles" })
  -- <leader> + g
  vim.keymap.set("n", "<leader>gf", fzf.git_files, { desc = "Files" })
  -- <leader> + h
  vim.keymap.set("n", "<leader>h:", fzf.commands, { desc = "Find commands" })
  vim.keymap.set("n", "<leader>h'", fzf.marks, { desc = "Find marks" })
  vim.keymap.set("n", '<leader>h"', fzf.registers, { desc = "Find registers" })
  vim.keymap.set("n", "<leader>ha", fzf.autocmds, { desc = "Autocommands" })
  vim.keymap.set("n", "<leader>hc", fzf.colorschemes, { desc = "Colorschemes" })
  vim.keymap.set("n", "<leader>hh", fzf.help_tags, { desc = "Help tags" })
  vim.keymap.set("n", "<leader>hH", fzf.highlights, { desc = "Highlights" })
  vim.keymap.set("n", "<leader>hk", fzf.keymaps, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>hm", fzf.manpages, { desc = "Manpages" })
  vim.keymap.set("n", "<leader>ho", fzf.nvim_options, { desc = "Options" })
  vim.keymap.set("n", "<leader>hz", fzf.spell_suggest, { desc = "Spelling" })
end)
