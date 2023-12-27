local prequire = require("utils.prequire")

---Filter out unwanted entries
---@param entry cmp.Entry
---@param _ cmp.Context ignored
---@return boolean
local function entry_filter(entry, _)
  return not vim.tbl_contains({
    "No matches found",
    "Searching...",
    "Workspace loading",
  }, entry.completion_item.label)
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      {
        "altermo/ultimate-autopair.nvim",
        branch = "v0.6", --recomended as each new version will have breaking changes
        opts = {
          tabout = {
            enable = true,
            map = "<tab>",
            cmap = "<tab>",
            hopout = true,
          },
        },
      },
    },
    event = { "InsertEnter" },
    config = function()
      local cmp = require("cmp")
      local luasnip = prequire("luasnip")
      local lspkind = require("lspkind")
      local border_opts = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }

      -- Insert mode setup
      cmp.setup({
        enabled = function()
          return not vim.b.large_file
        end,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          }),
        },
        snippet = {
          expand = luasnip and function(args)
            luasnip.lsp_expand(args.body)
          end or nil,
        },
        preselect = cmp.PreselectMode.None,
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        mapping = {
          ["<PageUp>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          }),
          ["<PageDown>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          }),
          ["<Up>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ["<Down>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "luasnip", max_item_count = 3 },
          { name = "nvim_lsp_signature_help" },
          {
            name = "nvim_lsp",
            max_item_count = 20,
            -- Suppress LSP completion when workspace is not ready yet
            entry_filter = entry_filter,
          },
          { name = "buffer", max_item_count = 8 },
          { name = "path" },
        }),
      })
    end,
  },
}
