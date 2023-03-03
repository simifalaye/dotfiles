return {
  {
    "ibhagwan/fzf-lua",
    branch = "main",
    dependencies = "nvim-tree/nvim-web-devicons",
    cond = vim.fn.executable("fzf") > 0,
    lazy = false,
    config = function()
      local fzf = require("fzf-lua")

      -- Setup keymaps
      -- -------------
      local m = require("utils.map")
      -- root
      m.nnoremap("<C-\\>", fzf.buffers, "Find Buffer")
      m.nnoremap("<C-f>", fzf.live_grep, "Find text")
      m.nnoremap("<C-p>", fzf.files, "Find File")
      m.nnoremap("<leader>.", fzf.resume, "Find resume")
      m.nnoremap("<leader>,", fzf.builtin, "Find Show")
      m.nnoremap("<leader>'", function()
        fzf.oldfiles({ cwd_only = true })
      end, "Find Recents (cwd)")
      m.nnoremap('<leader>"', fzf.oldfiles, "Find Recents")
      m.nnoremap("<leader>;", fzf.help_tags, "Find Help Tags")
      m.nnoremap("<leader>:", fzf.command_history, "Find Command History")
      m.nnoremap("<leader>/", fzf.search_history, "Find Search History")

      m.group("<leader>f", "+find")
      m.nnoremap("<leader>f'", fzf.marks, "Marks")
      m.nnoremap('<leader>f"', fzf.registers, "Registers")
      m.nnoremap("<leader>f*", fzf.blines, "(in) Buffer")
      m.nnoremap("<leader>fc", fzf.commands, "Commands")
      m.nnoremap("<leader>ff", function()
        fzf.files({
          fd_opts = "--no-ignore --color=never --type f --hidden --follow --exclude .git",
          rg_opts = "--no-ignore --color=never --files --hidden --follow -g '!.git'",
        })
      end, "Files (all)")
      m.nnoremap("<leader>fk", fzf.keymaps, "Keymaps")
      m.nnoremap("<leader>fm", fzf.man_pages, "Man Pages")
      m.nnoremap("<leader>fq", fzf.quickfix, "Quickfix")
      m.nnoremap("<leader>fs", function()
        fzf.live_grep({
          rg_opts = "--no-ignore --column --line-number --no-heading --color=always --smart-case --max-columns=512",
        })
      end, "Search (all)")
      -- git
      m.group("<leader>fg", "+git")
      m.nnoremap("<leader>fgb", fzf.git_branches, "Branches")
      m.nnoremap("<leader>fgc", fzf.git_commits, "Commits")
      m.nnoremap("<leader>fgC", fzf.git_bcommits, "Commits (buf)")
      m.nnoremap("<leader>fgf", fzf.git_files, "Files")
      m.nnoremap("<leader>fgs", fzf.git_status, "Status")
      -- lsp
      m.group("<leader>fl", "+lsp")
      m.nnoremap("<leader>flc", fzf.lsp_code_actions, "Code actions")
      m.nnoremap(
        "<leader>fld",
        fzf.lsp_document_diagnostics,
        "Diagnostics (document)"
      )
      m.nnoremap(
        "<leader>flD",
        fzf.lsp_workspace_diagnostics,
        "Diagnostics (workspace)"
      )
      m.nnoremap("<leader>fls", fzf.lsp_document_symbols, "Symbols (document)")
      m.nnoremap(
        "<leader>flS",
        fzf.lsp_workspace_symbols,
        "Symbols (workspace)"
      )
      -- notes
      local n_opts = { prompt = "Notes> ", cwd = "~/Notes" }
      m.group("<leader>fn", "+notes")
      m.nnoremap("<leader>fnf", function()
        fzf.files(n_opts)
      end, "Files")
      m.nnoremap("<leader>fng", function()
        fzf.live_grep(n_opts)
      end, "Search")
      -- yadm
      local yadm_git_dir = "$HOME/.local/share/yadm/repo.git"
      local yadm_cmd =
        string.format("yadm -C $HOME --yadm-repo %s", yadm_git_dir)
      local yadm_git_opts = {
        show_cwd_header = false,
        git_dir = yadm_git_dir,
      }
      local yadm_grep_opts = {
        prompt = "YadmGrep❯ ",
        cwd = "$HOME",
        cmd = ("%s grep --line-number --column --color=always"):format(
          yadm_cmd
        ),
        rg_glob = false, -- this isn't `rg`
      }
      m.group("<leader>fy", "+yadm")
      m.nnoremap("<leader>fyb", function()
        fzf.git_branches(yadm_git_opts)
      end, "Branches")
      m.nnoremap("<leader>fyc", function()
        fzf.git_commits(yadm_git_opts)
      end, "Commits")
      m.nnoremap("<leader>fyC", function()
        fzf.git_bcommits(yadm_git_opts)
      end, "Commits (buf)")
      m.nnoremap("<leader>fyf", function()
        fzf.git_files(yadm_git_opts)
      end, "Files")
      m.nnoremap("<leader>fyg", function()
        fzf.live_grep(yadm_grep_opts)
      end, "Grep")
      m.nnoremap("<leader>fys", function()
        fzf.git_status(yadm_git_opts)
      end, "Status")
    end,
  },
}
