local null_ls = require("null-ls")
local utils = require("utils")

return function(_, _)
  null_ls.register(null_ls.builtins.formatting.stylua.with({
    extra_args = function(params)
      if
        utils.file_exists(utils.join_paths(params.root, "stylua.toml"))
        or utils.file_exists(utils.join_paths(params.root, ".stylua.toml"))
      then
        return {}
      end
      return {
        "--column-width",
        "90",
        "--indent-width",
        "2",
        "--indent-type",
        "Spaces",
        "--quote-style",
        "AutoPreferDouble",
      }
    end,
  }))
end
