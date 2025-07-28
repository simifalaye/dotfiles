local vault_path = vim.fn.resolve(vim.fs.joinpath(vim.fn.expand("~"), "notes"))
local note_id_func = function(title)
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
end

local M = {
  "obsidian-nvim/obsidian.nvim",
}

M.dependencies = {
  "nvim-lua/plenary.nvim",
}

M.ft = "markdown"

M.cmd = { "Obsidian" }

M.keys = {
  { "<leader>nf", "<cmd>Obsidian quick_switch<CR>", desc = "Find" },
  { "<leader>ng", "<cmd>Obsidian search<CR>", desc = "Grep" },
  {
    "<leader>nn",
    function()
      local name = vim.fn.input("Enter fleeting note name: ", "")
      vim.cmd("Obsidian new_from_template " .. name .. " fleeting")
    end,
    desc = "New",
  },
  {
    "<leader>nN",
    function()
      local name = vim.fn.input("Enter permanent note name: ", "")
      vim.cmd("Obsidian new_from_template " .. name .. " permanent")
    end,
    desc = "New",
  },
  { "<leader>nM", "<cmd>Obsidian new_from_template<CR>", desc = "New (Template)" },
  { "<leader>no", "<cmd>Obsidian open<CR>", desc = "Open" },
  { "<leader>nt", "<cmd>Obsidian tags<CR>", desc = "Tags" },
}

M.init = function()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>n", group = "+Notes" } })
  end
  local ob_map = function(lhs, rhs, desc, opts)
    local o = opts or {}
    local mode = "n"
    if o.mode then
      mode = o.mode
      o.mode = nil
    end
    o = vim.tbl_extend("force", { desc = desc, buffer = true }, o)
    vim.keymap.set(mode, lhs, rhs, o)
  end
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("user_obsidian_buffer", {}),
    desc = "Setup obsidian.nvim buffer-local keymaps",
    pattern = vim.fs.joinpath(vault_path .. "/**.md"),
    callback = function()
      wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({ { "<localleader>n", group = "+notes" } }, { buffer = true })
      end
      -- ob_map("<CR>", "<cmd>Obsidian follow_link<CR>", "Follow link")
      ob_map("<localleader>nb", "<cmd>Obsidian backlinks<CR>", "Backlinks")
      ob_map(
        "<localleader>ne",
        "<cmd>Obsidian extract_note<CR>",
        "Extract Note",
        { mode = "v" }
      )
      ob_map("<localleader>ni", "<cmd>Obsidian template<CR>", "Insert Template")
      ob_map("<localleader>nl", "<cmd>Obsidian link<CR>", "Link Note", { mode = "v" })
      ob_map("<localleader>nl", "<cmd>Obsidian link_new<CR>", "Link New Note")
      ob_map("<localleader>nL", "<cmd>Obsidian links<CR>", "List Links")
      ob_map("<localleader>np", "<cmd>Obsidian paste_img<CR>", "Paste Image")
      ob_map(
        "<localleader>nr",
        "<cmd>Obsidian rename --dry-run<CR>",
        "Rename note (dry run)"
      )
      ob_map("<localleader>nR", "<cmd>Obsidian rename<CR>", "Rename note (dry run)")
      ob_map("<localleader>nt", "<cmd>Obsidian toc<CR>", "Table of Contents")
    end,
  })
end

M.opts = {
  legacy_commands = false,
  workspaces = {
    {
      name = "notes",
      path = vault_path,
    },
  },
  notes_subdir = ".",
  new_notes_location = "notes_subdir",
  note_id_func = note_id_func,
  preferred_link_style = "wiki", -- 'wiki' or 'markdown'.
  disable_frontmatter = true,
  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {},
    customizations = {},
  },
  follow_url_func = function(url)
    require("utils.cmd").sys_open(url)
  end,
  follow_img_func = function(img)
    require("utils.cmd").sys_open(img)
  end,
  open = {
    func = require("utils.cmd").sys_open,
  },
  backlinks = { parse_headers = false },
  ui = { enable = false },
  attachments = {
    img_folder = "assets/imgs",
  },
  footer = { enabled = true },
}

return M
