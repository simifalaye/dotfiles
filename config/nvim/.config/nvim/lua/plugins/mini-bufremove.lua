return {
  {
    "echasnovski/mini.bufremove",
    version = "*",
    event = "BufRead",
    keys = {
      {
        "<leader>x",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(
              ("Save changes to %q?"):format(vim.fn.bufname()),
              "&Yes\n&No\n&Cancel"
            )
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>X",
        "<cmd>lua MiniBufremove.delete(0, true)<CR>",
        desc = "E[x]it Buf!",
      },
    },
    config = true,
  },
}
