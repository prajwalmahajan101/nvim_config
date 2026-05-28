-- Spring Boot LSP attachment for application.yml / .properties + bean nav.
-- vscode-spring-boot-tools is installed via Mason (langs.lua).
-- This file wires the LSP server config so it attaches automatically when
-- a Java/Spring project is open.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        spring_boot_ls = {
          filetypes = { "java", "yaml", "properties", "jproperties" },
          root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" },
          init_options = { workspaceFolders = nil },
          single_file_support = false,
          on_attach = function(client, _)
            -- Spring tools provides codeLens; ensure it's on for the buffer.
            client.server_capabilities.codeLensProvider = client.server_capabilities.codeLensProvider or {}
          end,
        },
      },
    },
  },
}
