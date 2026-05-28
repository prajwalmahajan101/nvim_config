-- IDE-grade code folding via nvim-ufo.
-- Replaces LazyVim's default `foldmethod=indent` with folds derived from the
-- LSP (foldingRange) when available, falling back to treesitter, then indent.
--
-- Keymaps:
--   zR  open all folds
--   zM  close all folds
--   zK  peek the folded lines under the cursor (preview without opening)
--   za / zo / zc  toggle/open/close a single fold (built-in, still work)
--
-- LazyVim already configures `fillchars` for the fold glyphs, so the fold
-- column renders cleanly with no extra glyph setup.

return {
  -- Advertise the foldingRange capability so language servers send fold data.
  -- LazyVim applies `servers["*"].capabilities` to every server it sets up.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    init = function()
      -- ufo requires folds to start fully open and managed by a high foldlevel.
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      {
        "zK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            -- fall back to LSP hover if the cursor isn't on a fold
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold / hover",
      },
    },
    opts = {
      -- ufo's `provider_selector` only accepts a {main, fallback} pair, so to
      -- chain LSP → treesitter → indent we return a function that asks ufo for
      -- folds from each provider in turn, catching its UfoFallbackException.
      provider_selector = function(_, _, _)
        local function fallback(bufnr, err, provider)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return require("ufo").getFolds(bufnr, provider)
          end
          return require("promise").reject(err)
        end
        return function(bufnr)
          return require("ufo")
            .getFolds(bufnr, "lsp")
            :catch(function(err) return fallback(bufnr, err, "treesitter") end)
            :catch(function(err) return fallback(bufnr, err, "indent") end)
        end
      end,
    },
  },
}
