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
          settings = {
            json = {
              schemas = function()
                return require("schemastore").json.schemas()
              end,
              validate = { enable = true },
              format = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              schemaStore = {
                -- We provide the store via SchemaStore.nvim instead.
                enable = false,
                url = "",
              },
              schemas = function()
                return require("schemastore").yaml.schemas()
              end,
              validate = true,
              completion = true,
              hover = true,
              keyOrdering = false,           -- kube manifests rely on author ordering
              format = { enable = true, singleQuote = false },
            },
          },
        },
      },
    },
  },
}
