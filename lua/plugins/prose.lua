-- Prose / writing: vale-ls for markdown/text/rst style linting.
-- vale-ls binary is installed via Mason (added to langs.lua ensure_installed).

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vale_ls = {
          filetypes = { "markdown", "text", "rst", "tex", "asciidoc" },
          root_markers = { ".vale.ini", "vale.ini", ".git" },
          single_file_support = true,
        },
      },
    },
  },
}
