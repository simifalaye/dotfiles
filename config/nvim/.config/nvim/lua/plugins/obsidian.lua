return {
  {
    "epwalsh/obsidian.nvim",
    enabled = false,
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "ObsidianBacklinks",
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianQuickSwitch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianTags",
    },
    ft = "markdown",
    keys = {
      { "<leader>nb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>ndd", "<cmd>ObsidianToday<CR>", desc = "Today" },
      { "<leader>ndt", "<cmd>ObsidianTomorrow<CR>", desc = "Tomorrow" },
      { "<leader>ndy", "<cmd>ObsidianYesterday<CR>", desc = "Yesterday" },
      { "<leader>ne", "<cmd>ObsidianExtractNote<CR>", mode = "x", desc = "Extract Note" },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find" },
      { "<leader>ng", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
      { "<leader>nl", "<cmd>ObsidianLinks<CR>", desc = "Links" },
      { "<leader>nl", "<cmd>ObsidianLink<CR>", mode = "x", desc = "Link" },
      { "<leader>nL", ":ObsidianLinkNew ", mode = "x", desc = "Link New" },
      { "<leader>nn", "<cmd>ObsidianNew<CR>", desc = "New" },
      { "<leader>no", "<cmd>ObsidianOpen<CR>", desc = "Open" },
      { "<leader>nr", ":ObsidianRename ", desc = "Rename" },
      { "<leader>nt", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { "<leader>nT", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { "<leader>nw", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace Switch" },
    },
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({ ["<leader>n"] = { name = "+notes" } }, { mode = { "n", "x" } })
        wk.register({ ["<leader>nd"] = { name = "+find" } })
      end
    end,
    opts = {
      workspaces = {
        {
          name = "main",
          path = "~/knowledge_base",
          overrides = {
            notes_subdir = "notes",
            templates = {
              subdir = "templates",
              date_format = "%Y-%m-%d",
              time_format = "%H:%M",
            },
            daily_notes = {
              folder = "notes/daily",
              date_format = "%Y-%m-%d",
              alias_format = "%B %-d, %Y",
              template = "daily.md"
            },
            attachments = {
              img_folder = "assets",
            },
            note_id_func = function(title)
              if title ~= nil then
                return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                return tostring(os.time())
              end
            end,
          },
        },
      },
      new_notes_location = "notes_subdir",
      preferred_link_style = "wiki",
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<localleader>t"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { desc = "Toggle markdown checkbox", buffer = true },
        },
      },
      follow_url_func = function(url)
        require("utils.cmd").sys_open(url)
      end,
      ui = {
        checkboxes = {
          [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          ["x"] = { char = "✔", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "", hl_group = "ObsidianTilde" },
        },
      },
    },
  },
}
