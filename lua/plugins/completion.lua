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
  -- Parameter hints (signature help) as you type function arguments.
  {
    "saghen/blink.cmp",
    opts = {
      signature = { enabled = true },
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
