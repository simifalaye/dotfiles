_G.NLsp = _G.NLsp or {}
_G.NLsp.root_configs_cache = _G.NLsp.root_configs_cache or {}

--- A lspconfig on_new_config handler to allow for overriding default server
--- config with project-local config (including things like cmd) since neoconf
--- only allows for replacing config in the "settings". Note, we do this in the
--- on_new_config function and not on lspconfig load because this allows us to
--- check for project-local config even when not starting neovim in the project
--- directory.
--- TODO: Check whether neoconf adds support for overriding 'cmd' in the future.
---@param new_config table the configuration object to modify
---@param new_root_dir string the root dir of the project
local function default_on_new_config(new_config, new_root_dir)
  -- Load local conf from cache or file
  local conf = _G.NLsp.root_configs_cache[new_root_dir]
  if not conf then
    local fs = require("utils.fs")
    local conf_path = vim.fs.joinpath(new_root_dir, ".nlsp.json")
    if not fs.file_exists(conf_path) then
      return
    end
    conf = require("utils.json").read(conf_path)
    _G.NLsp.root_configs_cache[new_root_dir] = conf
  end
  -- Merge local conf with base conf
  local server_name = new_config.name
  if conf and conf[server_name] then
    -- Required to ensure original table variable is actually modified
    for k, v in pairs(vim.tbl_deep_extend("force", new_config, conf[server_name])) do
      new_config[k] = v
    end
  end
end

---@class UserLspKeys
---@field [1] string lhs
---@field [2] string|fun()|false rhs
---@field desc string?
---@field mode string|string[]|nil
---@field noremap boolean?
---@field remap boolean?
---@field expr boolean?
---@field id string?
---@field has string? map only if the client has a specific capability

--- Register lsp keys for the current buffer
---@param client vim.lsp.Client
---@param bufnr integer
---@param keys UserLspKeys[]
local function register_keys(client, bufnr, keys)
  for _, key in ipairs(keys) do
    if not key.has or client.server_capabilities[key.has .. "Provider"] then
      local opts = {}
      for k, v in pairs(key) do
        if type(k) ~= "number" and k ~= "mode" and k ~= "id" then
          opts[k] = v
        end
      end
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = bufnr
      vim.keymap.set(key.mode or "n", key[1], key[2], opts)
    end
  end
end

--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_clients.Filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
local function has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
end

--- An custom on_attach function which disables formatting for a client
---@param client vim.lsp.Client The lsp client object
local function disable_format_on_attach(client)
  client.server_capabilities.documentFormattingProvider = false
end

local schemastore = require("schemastore")
local efm_fs = require("efmls-configs.fs")
local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")
local cpplint = require("efmls-configs.linters.cpplint")
local efm_languages = {
  bash = {
    require("efmls-configs.linters.shellcheck"),
    {
      formatCommand = string.format(
        "%s -i 2 -ci -bn -filename '${INPUT}' -",
        efm_fs.executable("shfmt")
      ),
      formatStdin = true,
    },
  },
  c = { cpplint, nil },
  cpp = { cpplint, nil },
  lua = {
    {
      formatCanRange = true,
      formatCommand = string.format(
        "%s --color Never -s ${--range-start:charStart} ${--range-end:charEnd} -",
        efm_fs.executable("stylua")
      ),
      formatStdin = true,
      rootMarkers = { "stylua.toml", ".stylua.toml" },
    },
  },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  vue = { eslint, prettier },
  python = {
    require("efmls-configs.linters.flake8"),
    require("efmls-configs.formatters.black"),
  },
}

local server_configs = {
  ansiblels = {},
  bashls = {
    on_attach = disable_format_on_attach,
  },
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--header-insertion=iwyu",
      "--offset-encoding=utf-16",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    keys = {
      {
        "<localleader>A",
        "<cmd>ClangdSwitchSourceHeader<CR>",
        desc = "Alt file (lsp)",
      },
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
  efm = {
    filetypes = vim.tbl_keys(efm_languages),
    settings = {
      rootMarkers = { ".git/" },
      languages = efm_languages,
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
  },
  jsonls = {
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    on_attach = disable_format_on_attach,
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          maxPreload = 8000,
          checkThirdParty = false, -- fixes popup issue
        },
      },
    },
  },
  volar = {
    -- Enable volar takeover mode (use volar to replace tsserver)
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "json",
    },
    on_new_config = function(new_config, new_root_dir)
      local tsdk = "/usr/local/lib/node_modules/typescript/lib"
      local fs = require("utils.fs")
      local proj_ts = vim.fs.joinpath(new_root_dir, "node_modules", "typescript", "lib")
      if fs.dir_exists(proj_ts) then
        tsdk = proj_ts
      end
      new_config.init_options.typescript.tsdk = tsdk
    end,
    on_attach = disable_format_on_attach,
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
        schemas = schemastore.json.schemas(),
      },
    },
  },
}
local default_config = {
  flags = {
    debounce_text_changes = 150,
  },
}

local lz = require("utils.lazy").new("lsp", function()
  local lspconfig = require("lspconfig")
  local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  local user_lsp_config_grp_id = vim.api.nvim_create_augroup("UserLspConfig", {})

  -- Configure servers
  for name, config in pairs(server_configs) do
    local conf = vim.tbl_deep_extend("force", default_config, config or {})
    local keys = conf.keys
    local cmd = conf.cmd or lspconfig[name].document_config.default_config.cmd
    -- Override conf
    local on_new_config = conf.on_new_config
    conf.on_new_config = function(new_config, new_root_dir)
      if on_new_config ~= nil then
        on_new_config(new_config, new_root_dir)
      end
      default_on_new_config(new_config, new_root_dir)
    end
    if cmp_lsp_ok then
      conf.capabilities =
        vim.tbl_extend("force", conf.capabilities or {}, cmp_lsp.default_capabilities())
    end
    if not cmd or vim.fn.executable(cmd[1]) == 0 then
      conf.autostart = false
    end
    -- Register server-specific keymaps
    if keys then
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Register additional server specific keys",
        group = user_lsp_config_grp_id,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client and client.name == name then
            register_keys(client, bufnr, keys)
          end
        end,
      })
      conf.keys = nil
    end
    -- Register server
    lspconfig[name].setup(conf)
  end

  -- Setup main lsp attach handler for common config
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Setup common lsp configuration on lsp attach",
    group = user_lsp_config_grp_id,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      -- Enable lsp omnifunc and tagfunc for completion and goto def
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
      end

      -- Setup main keymaps
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({ { "gr", group = "+lsp" } }, { buffer = bufnr })
        wk.add({ { "grw", group = "+workspace" } }, { buffer = bufnr })
      end
      local keys = {
        {
          "grd",
          vim.lsp.buf.declaration,
          desc = "Goto Dec (lsp)",
          has = "declaration",
        },
        {
          "gri",
          vim.lsp.buf.implementation,
          desc = "Goto Impl (lsp)",
          has = "implementation",
        },
        {
          "grI",
          function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
              { bufnr = bufnr }
            )
          end,
          desc = "Toggle inlay hints (lsp)",
          has = "inlayHint",
        },
        {
          "grl",
          function()
            vim.lsp.codelens.refresh()
          end,
          desc = "Codelens refresh (lsp)",
          has = "codeLens",
        },
        {
          "grL",
          function()
            vim.lsp.codelens.run()
          end,
          desc = "Codelens run (lsp)",
          has = "codeLens",
        },
        {
          "grR",
          vim.lsp.buf.rename,
          desc = "Rename (lsp)",
          has = "rename",
        },
        {
          "grs",
          vim.lsp.buf.signature_help,
          desc = "Signature (lsp)",
          has = "signatureHelp",
        },
        {
          "grt",
          vim.lsp.buf.type_definition,
          desc = "Goto Type (lsp)",
          has = "typeDefinition",
        },
        {
          "grwa",
          vim.lsp.buf.add_workspace_folder,
          desc = "Add Folder (lsp)",
        },
        {
          "grwr",
          vim.lsp.buf.remove_workspace_folder,
          desc = "Remove Folder (lsp)",
        },
        {
          "grwl",
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          desc = "List Folders (lsp)",
        },
      }

      -- Register lsp keys
      register_keys(client, bufnr, keys)

      -- Setup autocmds
      if
        client.supports_method("textDocument/codeLens")
        and vim.g.user_codelens_enabled
      then
        vim.lsp.codelens.refresh()
        local codelens_groupid =
          vim.api.nvim_create_augroup("user_lsp_codelens_refresh", {})
        vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
          desc = "Refresh codelens",
          group = codelens_groupid,
          buffer = bufnr,
          callback = function()
            if not has_capability("textDocument/codeLens", { bufnr = bufnr }) then
              vim.api.nvim_del_augroup_by_name("user_lsp_codelens_refresh")
              return
            end
            if vim.g.user_codelens_enabled then
              vim.lsp.codelens.refresh()
            end
          end,
        })
      end
      if
        (
          client.supports_method("textDocument/semanticTokens/full")
          or client.supports_method("textDocument/semanticTokens/full/delta")
        ) and vim.lsp.semantic_tokens
      then
        if vim.b["user_semantic_tokens_enabled"] == nil then
          vim.b["user_semantic_tokens_enabled"] = vim.g.user_semantic_tokens_enabled
        end
        vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
          bufnr,
          client.id
        )
      end
      if client.supports_method("textDocument/documentHighlight") then
        local highlight_groupid =
          vim.api.nvim_create_augroup("user_lsp_document_highlight", {})
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          desc = "highlight references when cursor holds",
          group = highlight_groupid,
          buffer = bufnr,
          callback = function()
            if
              not has_capability("textDocument/documentHighlight", { bufnr = bufnr })
            then
              vim.api.nvim_del_augroup_by_name("user_lsp_document_highlight")
              return
            end
            vim.lsp.buf.document_highlight()
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          desc = "Clear references when cursor moves",
          group = highlight_groupid,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.clear_references()
          end,
        })
      end
      if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
        if vim.b.user_inlay_hints_enabled == nil then
          vim.b.user_inlay_hints_enabled = vim.g.user_inlay_hints_enabled
        end
        if vim.b.user_inlay_hints_enabled then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end
    end,
  })
  return true
end)
lz:autocmds({ "BufReadPre" })
