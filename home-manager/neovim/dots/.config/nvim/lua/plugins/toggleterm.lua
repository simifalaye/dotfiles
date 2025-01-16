local term_dirs = { "vertical", "horizontal", "tab", "float" }
local curr_term_dir = 2

local lazygit = nil

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    {
      "<leader>gg",
      function()
        if not lazygit then
          -- Setup lazygit term
          local Terminal = require("toggleterm.terminal").Terminal
          lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
            },
            on_open = function(term)
              if vim.fn.mapcheck("<esc>", "t") ~= "" then
                vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
              end
            end,
          })
        end
        lazygit:toggle()
      end,
      desc = "Lazygit",
    },
  },
  opts = {
    open_mapping = [[<c-\>]],
    shade_filetypes = {},
    direction = term_dirs[curr_term_dir],
    autochdir = true,
    persist_mode = true,
    insert_mappings = false,
    start_in_insert = true,
    highlights = {
      FloatBorder = { link = "FloatBorder" },
      NormalFloat = { link = "NormalFloat" },
    },
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local grp_id = vim.api.nvim_create_augroup("UserToggleTerm", {})
    vim.api.nvim_create_autocmd("TermOpen", {
      desc = "Register toggle term keymaps",
      group = grp_id,
      callback = function(_)
        if vim.bo.filetype == "toggleterm" then
          local o = { buffer = 0 }
          vim.keymap.set("t", [[<esc>]], [[<C-\><C-n>]], o)
          vim.keymap.set("t", [[<C-w>]], [[<C-\><C-n><C-w>]], o)
          vim.keymap.set("t", [[<C-t>]], function()
            curr_term_dir = curr_term_dir >= #term_dirs and 1 or curr_term_dir + 1
            vim.cmd("ToggleTerm")
            vim.cmd("ToggleTerm direction=" .. term_dirs[curr_term_dir])
            vim.api.nvim_feedkeys("i", "n", true)
          end, o)
        end
      end,
    })
  end,
}
