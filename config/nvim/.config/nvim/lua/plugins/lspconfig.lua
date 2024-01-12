return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "b0o/schemastore.nvim",
    },
    config = function()
      local manager = require("lspconfig.manager")
      ---@diagnostic disable-next-line: invisible
      local _start_new_client = manager._start_new_client
      ---Override lspconfig manager `_start_new_client()` method to silently
      ---quit if language server is not installed
      ---@param _ integer bufnr, ignored
      ---@param new_config table
      ---@vararg any
      ---@diagnostic disable-next-line: duplicate-set-field, invisible
      function manager:_start_new_client(_, new_config, ...)
        local bin = new_config and new_config.cmd and new_config.cmd[1]
        if bin and vim.fn.executable(bin) == 0 then
          return
        end
        return _start_new_client(self, _, new_config, ...)
      end

      local lsp = require("utils.lsp")
      local lspconfig = require("lspconfig")
      local server_configs = require("static.lsp-servers")

      --- Setup the configuration for an lsp server using the config file
      ---@param name string the name of the server
      local function configure_server(name)
        local conf = server_configs[name]
        conf.autostart = lsp.autostart
        local keys = conf.keys
        conf.keys = nil

        if keys then
          lsp.register_attach_handler(function(client, bufnr)
            if client.name == name then
              lsp.register_keys(client, bufnr, keys)
            end
          end)
        end
        lspconfig[name].setup(conf)
      end

      -- Configure all lsp servers that have a config file
      for _, file in
        ipairs(
          vim.fn.readdir(
            vim.fn.stdpath("config") .. "/lua/static/lsp-servers",
            [[v:val =~ '\.lua$']]
          )
        )
      do
        local name = file:gsub("%.lua$", "")
        if name ~= "init" and name ~= "default" then
          configure_server(name)
        end
      end
    end,
  },
}
