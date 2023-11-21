local function project_name_to_container_name(lspconfig)
  -- Notably _not_ including `compile_commands.json`, as we want the entire project
  local root_pattern = lspconfig.util.root_pattern(".git")
  -- Turn the name of the current file into the name of an expected container, assuming that
  -- the container running/building this file is named the same as the basename of the project
  -- that the file is in
  --
  -- The name of the current buffer
  local bufname = vim.api.nvim_buf_get_name(0)

  -- Turned into a filename
  local filename = lspconfig.util.path.is_absolute(bufname) and bufname
    or lspconfig.util.path.join(vim.loop.cwd(), bufname)

  -- Then the directory of the project
  local project_dirname = root_pattern(filename) or lspconfig.util.path.dirname(filename)

  -- And finally perform what is essentially a `basename` on this directory
  return project_dirname,
    vim.fn.fnamemodify(lspconfig.util.find_git_ancestor(project_dirname), ":t") .. "-dev"
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local prequire = require("utils.prequire")
      local lsp = require("utils.lsp")
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")

      -- Language server configuration
      local servers = {
        clangd = {
          cmd = (function()
            if vim.fn.executable("cclangd") == 1 then
              local project_dir, container_name =
                project_name_to_container_name(lspconfig)
              return {
                "cclangd",
                project_dir,
                container_name,
              }
            else
              return {
                "clangd",
                "--background-index",
                "--suggest-missing-includes",
                "--header-insertion=iwyu",
                "--offset-encoding=utf-16",
              }
            end
          end)(),
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false, -- fixes popup issue
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = schemastore.yaml.schemas(),
            },
          },
        },
      }

      -- Setup neodev (NOTE: Must come before any lspconfig setup)
      require("neodev").setup({})

      -- Setup diagnostics
      lsp.setup_diagnostics()

      -- Configure servers (use mason if available)
      local mason_lspconfig = prequire("mason-lspconfig")
      if mason_lspconfig then
        mason_lspconfig.setup_handlers({
          function(name) -- default handler
            lspconfig[name].setup(lsp.get_conf(servers[name]))
          end,
        })
      else
        for name, _ in ipairs(servers) do
          lspconfig[name].setup(lsp.get_conf(servers[name]))
        end
      end
    end,
  },
}
