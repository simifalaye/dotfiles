local fzf = reqcall("fzf-lua") ---@module 'fzf-lua'
local actions = reqcall("fzf-lua.actions")

local M = {
  "ibhagwan/fzf-lua",
  enabled = false,
  -- enabled = vim.fn.executable("fzf") > 0,
}

M.cmd = { "FzfLua" }

M.keys = {
  -- <leader>
  { "<leader>*", fzf.grep_cword, desc = "Grep word under cursor" },
  { "<leader>*", fzf.grep_visual, desc = "Grep visual selection", mode = "x" },
  { "<leader>#", fzf.grep_cword, desc = "Grep word under cursor" },
  { "<leader>#", fzf.grep_visual, desc = "Grep visual selection", mode = "x" },
  { "<leader>-", fzf.blines, desc = "Find lines in buffer" },
  { "<leader>-", fzf.blines, desc = "Find lines in selection", mode = "x" },
  { "<leader>[", fzf.oldfiles, desc = "Find oldfiles" },
  { "<leader>;", fzf.command_history, desc = "Find in command history" },
  { "<leader>:", fzf.commands, desc = "Find commands" },
  { "<leader>'", fzf.marks, desc = "Find marks" },
  { '<leader>"', fzf.registers, desc = "Find registers" },
  { "<leader><CR>", fzf.resume, desc = "Resume last find" },
  { "<leader>,", fzf.buffers, desc = "Find buffers" },
  { "<leader>.", fzf.files, desc = "Find files" },
  { "<leader>/", fzf.live_grep, desc = "Grep" },
  { "<leader>?", fzf.help_tags, desc = "Find help tags" },
  -- <leader> + f
  { "<leader>f<CR>", fzf.builtin, desc = "Pickers" },
  { "<leader>fa", fzf.autocmds, desc = "Autocommands" },
  { "<leader>fc", fzf.changes, desc = "Changes" },
  { "<leader>fC", fzf.colorschemes, desc = "Colorschemes" },
  { "<leader>fd", fzf.diagnostics_document, desc = "Diagnostics" },
  { "<leader>fD", fzf.diagnostics_workspace, desc = "Diagnostics (workspace)" },
  { "<leader>ff", fzf.git_files, desc = "Files (git)" },
  { "<leader>fg", fzf.grep, desc = "Grep" },
  { "<leader>fh", fzf.highlights, desc = "Highlights" },
  { "<leader>fj", fzf.jumps, desc = "Jumps" },
  { "<leader>fk", fzf.keymaps, desc = "Keymaps" },
  { "<leader>fl", fzf.loclist, desc = "Loclist" },
  { "<leader>fm", fzf.manpages, desc = "Manpages" },
  { "<leader>fo", fzf.nvim_options, desc = "Options" },
  { "<leader>fq", fzf.quickfix, desc = "Quickfix" },
  { "<leader>fs", fzf.lsp_document_symbols, desc = "Symbols" },
  { "<leader>fS", fzf.lsp_workspace_symbols, desc = "Symbols (workspace)" },
  { "<leader>fz", fzf.spell_suggest, desc = "Spelling" },
}

M.opts = {
  keymap = {
    -- Below are the default binds, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      -- true,        -- uncomment to inherit all the below in your custom config
      ["<C-_>"] = "toggle-help",
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
    },
    fzf = {
      -- fzf '--bind=' options
      -- true,        -- uncomment to inherit all the below in your custom config
      ["ctrl-z"] = "abort",
      ["ctrl-u"] = "unix-line-discard",
      ["ctrl-f"] = "half-page-down",
      ["ctrl-b"] = "half-page-up",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",
      ["alt-g"] = "first",
      ["alt-G"] = "last",
    },
  },
  actions = {
    -- Below are the default actions, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    files = {
      -- true,        -- uncomment to inherit all the below in your custom config
      -- Pickers inheriting these actions:
      --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
      --   tags, btags, args, buffers, tabs, lines, blines
      -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
      -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
      -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab firs
      ["alt-s"] = actions.file_split,
      ["alt-v"] = actions.file_vsplit,
      ["alt-t"] = actions.file_tabedit,
      ["alt-q"] = actions.file_sel_to_qf,
      ["alt-l"] = actions.file_sel_to_ll,
      ["enter"] = actions.file_edit_or_qf,
    },
  },
  defaults = { actions = {} },
  buffers = {
    show_unlisted = false,
    show_unloaded = true,
    ignore_current_buffer = false,
    no_action_set_cursor = true,
    current_tab_only = false,
    no_term_buffers = false,
    cwd_only = false,
    ls_cmd = "ls",
  },
  files = {
    actions = {
      ["alt-c"] = actions.change_cwd,
      ["alt-h"] = actions.toggle_hidden,
      ["alt-i"] = actions.toggle_ignore,
      ["alt-/"] = actions.toggle_dir,
    },
    fzf_opts = {
      ["--info"] = "inline-right",
    },
    find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/\.venv/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git --exclude .venv]],
    rg_opts = [[--no-messages --color=never --files --hidden --follow -g '!.git' -g '!.venv']],
  },
  grep = {
    rg_glob = true,
    actions = {
      ["alt-c"] = actions.change_cwd,
      ["alt-h"] = actions.toggle_hidden,
      ["alt-i"] = actions.toggle_ignore,
    },
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
}

return M
