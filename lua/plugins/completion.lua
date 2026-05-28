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
  -- blink.cmp deepening: cmdline polish, kind icons, per-ft sources, snippet preview.
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = {
          Text          = "",
          Method        = "󰊕",
          Function      = "󰊕",
          Constructor   = "",
          Field         = "",
          Variable      = "󰀫",
          Property      = "",
          Class         = "󰠱",
          Interface     = "",
          Struct        = "󰙅",
          Module        = "",
          Unit          = "",
          Value         = "󰎠",
          Enum          = "",
          EnumMember    = "",
          Keyword       = "󰌋",
          Constant      = "󰏿",
          Snippet       = "",
          Color         = "󰏘",
          File          = "󰈙",
          Reference     = "",
          Folder        = "󰉋",
          Event         = "",
          Operator      = "󰆕",
          TypeParameter = "",
        },
      },
      completion = {
        ghost_text = { enabled = true },
        accept = {
          auto_brackets = {
            enabled = true,
            kind_resolution = { enabled = true },
          },
        },
        menu = {
          auto_show = true,
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded", scrollbar = false },
        },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = true, auto_insert = true } },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql       = { "snippets", "dadbod", "buffer" },
          mysql     = { "snippets", "dadbod", "buffer" },
          plsql     = { "snippets", "dadbod", "buffer" },
          gitcommit = { "git", "snippets", "buffer" },
          markdown  = { "snippets", "lsp", "path", "buffer", "dictionary", "emoji" },
          text      = { "snippets", "buffer", "dictionary", "emoji" },
        },
        providers = {
          buffer = { score_offset = -3 }, -- prefer lsp/snippets over plain words
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
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
