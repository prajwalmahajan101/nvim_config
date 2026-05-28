-- IDE quality-of-life extras — the VSCode-equivalent UX pieces.
--
-- LazyVim extras (test.core, ui.treesitter-context, editor.illuminate,
-- editor.aerial, editor.navic, editor.harpoon2) are declared in
-- ../../lazyvim.json so they auto-import in the correct spec order.

return {
  -- ── Multi-cursor (Ctrl+D / Ctrl+N like VSCode "Add Selection to Next Find") ─
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Multi-cursor: add next match" },
      { "<C-Up>", mode = { "n", "x" }, desc = "Multi-cursor: cursor up" },
      { "<C-Down>", mode = { "n", "x" }, desc = "Multi-cursor: cursor down" },
    },
    init = function()
      vim.g.VM_default_mappings = 1
      vim.g.VM_silent_exit = 1
      vim.g.VM_show_warnings = 0
    end,
  },

  -- ── Render markdown beautifully inside the buffer ──────────────────────
  -- (Already loaded via lang.markdown, but ensure good defaults)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = { sign = false },
      code = { sign = false, width = "block", left_pad = 2, right_pad = 2 },
      checkbox = {
        unchecked = { icon = " 󰄱 " },
        checked = { icon = " 󰱒 " },
      },
    },
  },

  -- ── Better diagnostics UI (trouble.nvim is LazyVim default; tweak it) ──
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
      auto_close = true,
      icons = {
        indent = {
          top         = "│ ",
          middle      = "├╴",
          last        = "└╴",
          fold_open   = " ",
          fold_closed = " ",
          ws          = "  ",
        },
        folder_closed = " ",
        folder_open   = " ",
        kinds = {
          Array         = " ",
          Boolean       = "󰨙 ",
          Class         = "󰠱 ",
          Constant      = "󰏿 ",
          Constructor   = " ",
          Enum          = " ",
          EnumMember    = " ",
          Event         = " ",
          Field         = " ",
          File          = " ",
          Function      = "󰊕 ",
          Interface     = " ",
          Key           = " ",
          Method        = "󰊕 ",
          Module        = " ",
          Namespace     = "󰦮 ",
          Null          = " ",
          Number        = "󰎠 ",
          Object        = " ",
          Operator      = " ",
          Package       = " ",
          Property      = " ",
          String        = " ",
          Struct        = "󰙅 ",
          TypeParameter = " ",
          Variable      = "󰀫 ",
        },
      },
    },
  },

  -- ── nvim-treesitter-context tuning (compact header) ────────────────────
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 3, multiline_threshold = 1, trim_scope = "outer" },
  },

  -- ── Harpoon2 explicit keymaps under <leader>h ───────────────────────────
  -- The plugin itself ships via the editor.harpoon2 extra; we only wire keys.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end,                       desc = "Harpoon: add file" },
      { "<leader>hh", function() local h = require("harpoon"); h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon: quick menu" },
      { "<leader>hn", function() require("harpoon"):list():next() end,                      desc = "Harpoon: next" },
      { "<leader>hp", function() require("harpoon"):list():prev() end,                      desc = "Harpoon: prev" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end,                   desc = "Harpoon: slot 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end,                   desc = "Harpoon: slot 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end,                   desc = "Harpoon: slot 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end,                   desc = "Harpoon: slot 4" },
      { "<leader>h5", function() require("harpoon"):list():select(5) end,                   desc = "Harpoon: slot 5" },
    },
  },

  -- ── Better quickfix: editable, previewable, prettier ───────────────────
  -- Pairs well with grug-far / LSP references (which populate the quickfix
  -- list). Edit lines in the list and `:w` to write changes back to files.
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    keys = {
      { "<leader>xq", function() require("quicker").toggle() end, desc = "Toggle quickfix (quicker)" },
      { "<leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle loclist (quicker)" },
    },
    opts = {
      keys = {
        { ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand quickfix context" },
        { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
      },
    },
  },
}
