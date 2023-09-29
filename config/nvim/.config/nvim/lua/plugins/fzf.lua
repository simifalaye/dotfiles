local reqcall = require("utils.reqcall")
local fzf = reqcall("fzf-lua") ---@module 'fzf-lua'

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>;", fzf.files, desc = "File Picker" },
      {
        "<leader>'",
        function()
          fzf.oldfiles({ cwd_only = true })
        end,
        desc = "Recent File Picker",
      },
      { "<leader>,", fzf.buffers, desc = "Buffer Picker" },
      { "<leader>.", fzf.resume, desc = "Resume Picker" },
      { "<leader>/", fzf.live_grep, desc = "Global Live Search" },

      { "<leader>f:", fzf.command_history, desc = "Command History" },
      { "<leader>f'", fzf.marks, desc = "Marks" },
      { '<leader>f"', fzf.registers, desc = "Registers" },
      { "<leader>f,", fzf.grep_visual, desc = "Grep Visual", mode = "v" },
      { "<leader>f,", fzf.grep_cword, desc = "Grep Word" },
      { "<leader>f<", fzf.grep_cWORD, desc = "Grep WORD" },
      { "<leader>f.", fzf.changes, desc = "Changes" },
      { "<leader>f/", fzf.search_history, desc = "Search History" },
      { "<leader>f?", fzf.builtin, desc = "Providers" },
      { "<leader>fb", fzf.blines, desc = "Buffer Lines" },
      { "<leader>fc", fzf.commands, desc = "Commands" },
      {
        "<leader>ff",
        function()
          local files = require("fzf-lua").defaults.files
          fzf.files({
            rg_opts = "--no-ignore " .. files.rg_opts,
            fd_opts = "--no-ignore " .. files.fd_opts,
          })
        end,
        desc = "Files (All)",
      },
      {
        "<leader>fg",
        function()
          local grep = require("fzf-lua").defaults.grep
          fzf.live_grep({
            rg_opts = "--no-ignore " .. grep.rg_opts,
          })
        end,
        desc = "Live Grep (All)",
      },
      { "<leader>fh", fzf.help_tags, desc = "Help" },
      { "<leader>fk", fzf.keymaps, desc = "Keymaps" },
      { "<leader>fm", fzf.man_pages, desc = "Man Pages" },
      { "<leader>fr", fzf.oldfiles, desc = "Recent Files (All)" },
      { "<leader>fz", fzf.spell_suggest, desc = "Spell" },
    },
    init = function()
      -- Lsp additions
      local lsp = require("utils.lsp")
      lsp.register_attach_handler(function(client, bufnr)
        lsp.register_keys(client, bufnr, {
          {
            "<localleader>D",
            fzf.diagnostics_document,
            desc = "Doc Diagnostics (lsp)",
          },
          {
            "<localleader>s",
            fzf.lsp_document_symbols,
            desc = "Document Symbols (lsp)",
            has = "documentSymbol",
          },
          {
            "gd",
            fzf.lsp_definitions,
            desc = "Goto Def (lsp)",
            has = "definition",
          },
          {
            "gi",
            fzf.lsp_implementations,
            desc = "Goto Impl (lsp)",
            has = "implementation",
          },
          {
            "gr",
            fzf.lsp_references,
            desc = "Goto Ref (lsp)",
            has = "references",
          },
          {
            "gz",
            fzf.lsp_typedefs,
            desc = "Goto Type (lsp)",
            has = "typeDefinition",
          },
          {
            "<localleader>wd",
            fzf.diagnostics_workspace,
            desc = "Diagnostics (lsp)",
          },
          {
            "<localleader>ws",
            fzf.lsp_workspace_symbols,
            desc = "Symbols (lsp)",
            has = "workspaceSymbol",
          },
        })
      end)
    end,
    config = function()
      local function dropdown(opts)
        opts = opts or { winopts = {} }
        return vim.tbl_deep_extend("force", {
          fzf_opts = { ["--layout"] = "reverse" },
          winopts = {
            height = 0.70,
            width = 0.55,
            row = 0.1,
            preview = { hidden = "hidden", layout = "vertical", vertical = "up:50%" },
          },
        }, opts)
      end

      require("fzf-lua").setup({
        buffers = dropdown({
          fzf_opts = { ["--delimiter"] = "' '", ["--with-nth"] = "-1.." },
        }),
      })
    end,
  },
}
