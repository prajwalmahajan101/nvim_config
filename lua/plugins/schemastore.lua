-- SchemaStore: massive JSON/YAML schema collection auto-attached to jsonls/yamlls.
-- The plugin itself is already in lazy-lock.json (dep of LazyVim lang.json/yaml);
-- here we wire it into the LSP server opts.

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings = new_config.settings or {}
            new_config.settings.json = new_config.settings.json or {}
            new_config.settings.json.schemas = vim.list_extend(
              new_config.settings.json.schemas or {},
              require("schemastore").json.schemas()
            )
          end,
          settings = {
            json = { validate = { enable = true }, format = { enable = true } },
          },
        },
        yamlls = {
          on_new_config = function(new_config)
            new_config.settings = new_config.settings or {}
            new_config.settings.yaml = new_config.settings.yaml or {}
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              schemaStore = { enable = false, url = "" },
              validate = true,
              completion = true,
              hover = true,
              keyOrdering = false,
              format = { enable = true, singleQuote = false },
            },
          },
        },
      },
    },
  },
}
