return {
  {
    "mickael-menu/zk-nvim",
    lazy = false,
    keys = {
      {
        "<leader>nf",
        "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        desc = "Find",
        silent = false,
      },
      {
        "<leader>nf",
        ":'<,'>ZkMatch<CR>",
        mode = "v",
        desc = "Find Selected",
        silent = false,
      },
      {
        "<leader>nd",
        "<cmd>ZkNew { dir = 'daily', date = 'today' }<CR>",
        desc = "Daily Today",
        silent = false,
      },
      {
        "<leader>nD",
        "<cmd>ZkNew { dir = 'daily', date = 'yesterday' }<CR>",
        desc = "Daily Yesterday",
        silent = false,
      },
      {
        "<leader>nn",
        "<cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        desc = "New",
        silent = false,
      },
      {
        "<leader>no",
        "<cmd>ZkNotes { sort = { 'modified' } }<CR>",
        desc = "Open",
        silent = false,
      },
      {
        "<leader>nr",
        "<cmd>ZkNew { title = vim.fn.input('Title: '), dir = 'reference' }<CR>",
        desc = "New Ref Note",
        silent = false,
      },
      {
        "<leader>nt",
        "<leader>zt",
        "<cmd>ZkTags<CR>",
        desc = "Tags",
        silent = false,
      },
    },
    init = function()
      local m = require("utils.map")
      m.group("<leader>n", "+notes", { "n", "v" })
    end,
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          -- `config` is passed to `vim.lsp.start_client(config)`
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            on_attach = function()
              local o = { silent = false }
              local m = require("utils.map")
              -- Open the link under the caret.
              m.nnoremap(
                "<CR>",
                "<cmd>lua vim.lsp.buf.definition()<CR>",
                "Goto",
                o
              )
              -- Create a new note after asking for its title.
              -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
              m.nnoremap(
                "<leader>nn",
                "<cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
                "New",
                o
              )
              -- Open notes linking to the current buffer.
              m.nnoremap("<leader>nb", "<cmd>ZkBacklinks<CR>", "Backlinks", o)
              -- Insert link at cursor location or around selected text
              m.nnoremap(
                "<leader>ni",
                "<cmd>ZkInsertLink<CR>",
                "Insert Link",
                o
              )
              m.vnoremap(
                "<leader>ni",
                ":'<,'>ZkInsertLinkAtSelection<CR>",
                "Insert Link",
                o
              )
              -- Alternative for backlinks using pure LSP and showing the source context.
              --map('n', '<leader>zb', '<cmd>lua vim.lsp.buf.references()<CR>', o)
              -- Open notes linked by the current buffer.
              m.nnoremap("<leader>nl", "<cmd>ZkLinks<CR>", "Links", o)
              -- Preview a linked note.
              m.nnoremap(
                "K",
                "<cmd>lua vim.lsp.buf.hover()<CR>",
                "Preview Note",
                o
              )
              -- Open the code actions for a visual selection.
              m.vnoremap(
                "<leader>na",
                ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
                "Code Action",
                o
              )
            end,
          },

          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
  },
}
