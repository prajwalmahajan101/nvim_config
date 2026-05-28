-- Prose / writing: vale-ls for markdown/text/rst style linting.
-- vale-ls binary is installed via Mason (added to langs.lua ensure_installed).

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vale_ls = {
          filetypes = { "markdown", "text", "rst", "tex", "asciidoc" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".vale.ini", "vale.ini")(fname) or util.find_git_ancestor(fname)
          end,
          single_file_support = true,
        },
      },
    },
  },
}
