-- VSCode-style inline documentation UX.
--
-- 1. blink.cmp signature help — parameter hints popup while you type a call's
--    arguments (the active parameter is highlighted). LazyVim ships this
--    disabled; we turn it on. The completion-menu documentation panel is
--    already auto-shown by LazyVim's blink defaults, so nothing to add there.
--
-- 2. neogen docstring/JSDoc generation — already enabled via the
--    coding.neogen extra. Bound to <leader>cn ("Generate Annotations"):
--    put the cursor on a function/class and it inserts a docstring skeleton.
--    Here we just pin the annotation style per language.

return {
  -- blink.cmp polish: ghost text, super-tab, bordered signature, mono icons.
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        ghost_text = { enabled = true },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          auto_show = true,
          border = "rounded",
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          buffer = { score_offset = -3 }, -- prefer lsp/snippets over plain words
        },
      },
    },
  },

  -- Docstring / JSDoc conventions for <leader>cn.
  {
    "danymat/neogen",
    opts = {
      languages = {
        python = { template = { annotation_convention = "google_docstrings" } },
        typescript = { template = { annotation_convention = "jsdoc" } },
        typescriptreact = { template = { annotation_convention = "jsdoc" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        javascriptreact = { template = { annotation_convention = "jsdoc" } },
      },
    },
  },
}
