-- Server-side LSP tuning for the languages the user actually writes.
-- Extends the lspconfig spec LazyVim already builds from the lang.* extras.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- inlay hints + codelens are LazyVim-global toggles; turn them on.
      inlay_hints = { enabled = true },
      codelens = { enabled = true },

      servers = {
        -- ── Python: basedpyright (FastAPI / Django) ────────
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard", -- "strict" is too noisy for Django ORM
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  variableTypes = true,
                  callArgumentNames = true,
                  functionReturnTypes = true,
                  genericTypes = false,
                },
              },
            },
          },
        },

        -- ── Go: gopls (with staticcheck + hints) ───────────
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              semanticTokens = true,
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
