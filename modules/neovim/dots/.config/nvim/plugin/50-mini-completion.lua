MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-mini/mini.completion",
    checkout = "stable",
    depends = {
      {
        source = "nvim-mini/mini.snippets",
        checkout = "stable",
      },
      "rafamadriz/friendly-snippets",
    },
  })

  local minisnippets = require("mini.snippets")

  local gen_loader = minisnippets.gen_loader
  minisnippets.setup({
    snippets = {
      -- Load custom file with global snippets first (adjust for Windows)
      gen_loader.from_file(
        vim.fs.joinpath(vim.fn.stdpath("config"), "snippets", "all.json")
      ),
      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      gen_loader.from_lang(),
    },
  })
  minisnippets.start_lsp_server()

  local minicomp = require("mini.completion")

  -- Don't show 'Text' suggestions and prioritize snippets
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return minicomp.default_process_items(items, base, process_items_opts)
  end
  minicomp.setup({
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = process_items,
    },
    -- Module mappings. Use `''` (empty string) to disable one. Some of them
    -- might conflict with system mappings.
    mappings = {
      -- Force two-step/fallback completions
      force_twostep = "<C-Space>",
      force_fallback = "<C-g>",
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
  })

  -- Set up LSP part of completion
  local on_attach = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end
  vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })
  if vim.fn.has("nvim-0.11") == 1 then
    vim.lsp.config("*", { capabilities = minicomp.get_lsp_capabilities() })
  end

  -- Setup kind icons
  local mini_icons_ok, mini_icons = pcall(require, "mini.icons")
  if mini_icons_ok then
    mini_icons.tweak_lsp_kind()
  end
end)
