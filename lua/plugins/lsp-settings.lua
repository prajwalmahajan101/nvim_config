-- Server-side LSP tuning for the languages the user actually writes.
-- Extends the lspconfig spec LazyVim already builds from the lang.* extras.

return {
  -- ── Code-action menu with diff preview + grouping (<leader>ca) ──
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<leader>ca",
        function() require("actions-preview").code_actions() end,
        mode = { "n", "x" },
        desc = "Code action (preview)",
      },
    },
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = { width = 0.8, height = 0.9, preview_cutoff = 20, preview_height = function(_, _, max_lines) return max_lines - 15 end },
      },
    },
  },

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

        -- ── TS/JS: vtsls/tsserver (auto-import, single quotes, inlay hints) ──
        -- LazyVim picks tsserver by default; vtsls is supported by the same opts.
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames           = { enabled = "literals" },
                parameterTypes           = { enabled = true },
                variableTypes            = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes  = { enabled = true },
                enumMemberValues         = { enabled = true },
              },
              preferences = {
                importModuleSpecifier              = "non-relative",
                quoteStyle                         = "single",
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText  = true,
              },
              suggest = { completeFunctionCalls = true },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames           = { enabled = "literals" },
                parameterTypes           = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
              },
              preferences = {
                importModuleSpecifier              = "non-relative",
                quoteStyle                         = "single",
                includeCompletionsForModuleExports = true,
              },
            },
          },
        },
        tsserver = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier              = "non-relative",
                quoteStyle                         = "single",
                includeCompletionsForModuleExports = true,
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = { useFlatConfig = true },
            format = false, -- prettier owns formatting
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
