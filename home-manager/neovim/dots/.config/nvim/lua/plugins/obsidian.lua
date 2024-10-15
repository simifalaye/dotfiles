local vault_path = vim.fn.resolve(vim.fs.joinpath(vim.fn.expand("~"), "knowledge_base"))
if not require("utils.fs").dir_exists(vault_path) then
  return
end

local lz = require("utils.lazy").new("obsidian", function()
  require("utils.lazy").ensure_module("telescope")
  require("obsidian").setup({
    workspaces = {
      {
        name = "notes",
        path = vault_path,
      },
    },
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
    preferred_link_style = "markdown", -- 'wiki' or 'markdown'.
    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {},
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    ui = { enable = false },
    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end
      local out = { aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      require("utils.cmd").sys_open(url)
    end,
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local name = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the name.
        for _ = 1, 4 do
          name = name .. string.char(math.random(65, 90))
        end
      end
      return name
    end,
  })
  return true
end)
lz:events({ "BufReadPre", "BufNewFile" }, vim.fs.joinpath(vault_path .. "/**.md"))

-- Keymaps
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>n", group = "+notes" } })
end
lz:key("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Find" })
lz:key("n", "<leader>ng", "<cmd>ObsidianSearch<CR>", { desc = "Grep" })
lz:key("n", "<leader>nn", "<cmd>ObsidianNew<CR>", { desc = "New" })
lz:key("n", "<leader>nN", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "New (Template)" })
lz:key("n", "<leader>no", "<cmd>ObsidianOpen<CR>", { desc = "Open" })
lz:key("n", "<leader>nt", "<cmd>ObsidianTags<CR>", { desc = "Tags" })

-- Autocmds
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("user_oil_buffer", {}),
  desc = "Setup obsidian.nvim buffer-local keymaps",
  pattern = vim.fs.joinpath(vault_path .. "/**.md"),
  callback = function()
    wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({ { "<localleader>n", group = "+notes" } }, { buffer = true })
    end
    vim.keymap.set("n", "<cr>", function()
      return require("obsidian").util.smart_action()
    end, { buffer = true, expr = true, desc = "Smart Follow" })
    vim.keymap.set("n", "<localleader>nb", function()
      vim.cmd("ObsidianBacklinks")
    end, { buffer = true, desc = "Backlinks" })
    vim.keymap.set("v", "<localleader>ne", function()
      vim.cmd("ObsidianExtractNote")
    end, { buffer = true, desc = "Extract Note" })
    vim.keymap.set("n", "<localleader>ni", function()
      vim.cmd("ObsidianTemplate")
    end, { buffer = true, desc = "Insert Template" })
    vim.keymap.set("v", "<localleader>nl", function()
      vim.cmd("ObsidianLink")
    end, { buffer = true, desc = "Link Note" })
    vim.keymap.set("n", "<localleader>nl", function()
      vim.cmd("ObsidianLinkNew")
    end, { buffer = true, desc = "Link New Note" })
    vim.keymap.set("n", "<localleader>nL", function()
      vim.cmd("ObsidianLinks")
    end, { buffer = true, desc = "List Links" })
    vim.keymap.set("n", "<localleader>np", function()
      vim.cmd("ObsidianPasteImg")
    end, { buffer = true, desc = "Paste Image" })
    vim.keymap.set("n", "<localleader>nt", function()
      vim.cmd("ObsidianTOC")
    end, { buffer = true, desc = "Table of Contents" })
  end,
})
