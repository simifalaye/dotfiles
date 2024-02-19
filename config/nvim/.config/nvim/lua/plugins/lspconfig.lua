_G.NLsp = _G.NLsp or {}
_G.NLsp.root_configs = _G.NLsp.root_configs or {}

--- A lspconfig on_new_config handler to allow for overriding default server
--- config with project-local config (including things like cmd) since neoconf
--- only allows for replacing config in the "settings".
--- TODO: Check whether neoconf adds support for overriding 'cmd' in the future
---@param new_config table the configuration object to modify
---@param new_root_dir string the root dir of the project
local function on_new_config(new_config, new_root_dir)
  local conf = _G.NLsp.root_configs[new_root_dir]
  if not conf then
    local fs = require("utils.fs")
    local conf_path = fs.join_paths(new_root_dir, ".nlsp.json")
    if not fs.file_exists(conf_path) then
      return
    end
    conf = require("utils.json").read(conf_path)
    _G.NLsp.root_configs[new_root_dir] = conf
  end

  local server_name = new_config.name
  if conf[server_name] then
    -- Required to ensure original table variable is actually modified
    for k, v in pairs(vim.tbl_deep_extend("force", new_config, conf[server_name])) do
      new_config[k] = v
    end
  end
end

local M = { "neovim/nvim-lspconfig" }

M.event = "BufReadPre"

M.dependencies = {
  { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
  { "folke/neodev.nvim", config = true },
  { "j-hui/fidget.nvim", config = true },
  "b0o/schemastore.nvim",
}

M.config = function()
  local lsp = require("utils.lsp")
  local lspconfig = require("lspconfig")
  local server_configs = require("static.lsp_server_config")
  local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  local user_lsp_config_grp_id = vim.api.nvim_create_augroup("UserLspConfig", {})

  --- Setup the configuration for an lsp server using the config file
  ---@param name string the name of the server
  local function configure_server(name)
    local conf = server_configs[name]
    local keys = conf.keys
    local cmd = conf.cmd or lspconfig[name].document_config.default_config.cmd
    local def_on_new_config = conf.on_new_config
    -- Override conf
    conf.on_new_config = function(new_config, new_root_dir)
      if def_on_new_config then
        def_on_new_config(new_config, new_root_dir)
      end
      on_new_config(new_config, new_root_dir)
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
          if client.name == name then
            lsp.register_keys(client, bufnr, keys)
          end
        end,
      })
      conf.keys = nil
    end
    -- Register server
    lspconfig[name].setup(conf)
  end

  -- Configure all lsp servers that have a config file
  for _, file in
    ipairs(
      vim.fn.readdir(
        vim.fn.stdpath("config") .. "/lua/static/lsp_server_config",
        [[v:val =~ '\.lua$']]
      )
    )
  do
    local name = file:gsub("%.lua$", "")
    if name ~= "init" then
      configure_server(name)
    end
  end

  -- Setup main lsp attach handler for common config
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Setup common lsp configuration on lsp attach",
    group = user_lsp_config_grp_id,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- Enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Setup main keymaps
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({ ["<localleader>w"] = { name = "+workspace" } }, { buffer = bufnr })
      end
      local keys = {
        { "]d", vim.diagnostic.goto_next, desc = "Diagnostic (lsp)" },
        { "[d", vim.diagnostic.goto_prev, desc = "Diagnostic (lsp)" },
        {
          "<localleader>a",
          vim.lsp.buf.code_action,
          desc = "Code Action (lsp)",
          mode = { "n", "v" },
          has = "codeAction",
        },
        {
          "<localleader>d",
          vim.diagnostic.open_float,
          desc = "Line Diagnostics (lsp)",
        },
        {
          "<localleader>D",
          vim.diagnostic.setloclist,
          desc = "Doc Diagnostics (lsp)",
        },
        {
          "<localleader>f",
          function()
            vim.lsp.buf.format({ async = true })
          end,
          mode = "n",
          desc = "Format Doc (lsp)",
          has = "formatting",
        },
        {
          "<localleader>f",
          function()
            vim.lsp.buf.format({ async = true })
          end,
          mode = "v",
          desc = "Format Doc (lsp)",
          has = "rangeFormatting",
        },
        {
          "<localleader>r",
          vim.lsp.buf.rename,
          desc = "Rename (lsp)",
          has = "rename",
        },
        {
          "<localleader>l",
          function()
            vim.lsp.codelens.refresh()
          end,
          desc = "Codelens refresh (lsp)",
          has = "codeLens",
        },
        {
          "<localleader>L",
          function()
            vim.lsp.codelens.run()
          end,
          desc = "Codelens run (lsp)",
          has = "codeLens",
        },
        {
          "<localleader>wa",
          vim.lsp.buf.add_workspace_folder,
          desc = "Add Folder (lsp)",
        },
        {
          "<localleader>wr",
          vim.lsp.buf.remove_workspace_folder,
          desc = "Remove Folder (lsp)",
        },
        {
          "<localleader>wl",
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          desc = "List Folders (lsp)",
        },
        { "gd", vim.lsp.buf.definition, desc = "Goto Def (lsp)", has = "definition" },
        {
          "gD",
          vim.lsp.buf.declaration,
          desc = "Goto Dec (lsp)",
          has = "declaration",
        },
        {
          "gK",
          vim.lsp.buf.signature_help,
          desc = "Signature (lsp)",
          has = "signatureHelp",
        },
        {
          "gi",
          vim.lsp.buf.implementation,
          desc = "Goto Impl (lsp)",
          has = "implementation",
        },
        { "gr", vim.lsp.buf.references, desc = "Goto Ref (lsp)", has = "references" },
        {
          "gz",
          vim.lsp.buf.type_definition,
          desc = "Goto Type (lsp)",
          has = "typeDefinition",
        },
        { "K", vim.lsp.buf.hover, desc = "Hover (lsp)", has = "hover" },
      }

      -- Register lsp keys
      lsp.register_keys(client, bufnr, keys)

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
            if not lsp.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
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
              not lsp.has_capability("textDocument/documentHighlight", { bufnr = bufnr })
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
    end,
  })
end

return M
