-- High-leverage editor tools layered on top of LazyVim's defaults.
--   • todo-comments    — TODO/FIXME/HACK highlight + project-wide search
--   • zen-mode/twilight — distraction-free writing for docs & long files
--   • markdown-preview — browser preview for .md (live, hot-reload)
--   • nvim-jqx        — interactive JSON inspector / jq runner (API work)
--   • oil.nvim        — edit your filesystem as a buffer
--   • nvim-spider     — smarter w/e/b motion (snake_case / camelCase aware)

return {
  -- ── TODO / FIXME / NOTE highlighting + telescope-style search ──
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false }, -- keep the signcolumn clean; rely on highlight
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev TODO comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Search TODOs" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Search TODO/FIX" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                      desc = "TODOs in Trouble" },
    },
  },

  -- ── Distraction-free writing (great for markdown / PlantUML editing) ──
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen mode" } },
    opts = {
      window = { width = 0.78, options = { number = false, relativenumber = false } },
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = false },
      },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = { { "<leader>uZ", "<cmd>Twilight<cr>", desc = "Toggle Twilight (dim)" } },
    opts = { context = 12, treesitter = true },
  },

  -- ── Markdown preview in the browser ──
  -- :MarkdownPreview to start, :MarkdownPreviewStop to stop. Uses node.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>cP", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown: toggle preview" },
    },
    init = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- ── JSON / jq inspector — perfect for poking API responses ──
  -- :Jqx to open the picker, q to close. With visual selection, runs jq.
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
    keys = {
      { "<leader>cJ", "<cmd>JqxList<cr>",  ft = { "json", "yaml" }, desc = "JSON: tree picker" },
      { "<leader>cq", "<cmd>JqxQuery<cr>", ft = { "json", "yaml" }, desc = "JSON: jq query" },
    },
  },

  -- ── Oil: edit the filesystem as a buffer (faster than neo-tree for renames/moves) ──
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-",         "<cmd>Oil<cr>",                              desc = "Open parent directory (oil)" },
      { "<leader>fo", function() require("oil").toggle_float() end, desc = "Oil (floating)" },
    },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      float = { border = "rounded", max_width = 100, max_height = 30 },
    },
  },

  -- ── Spider: word motion that respects snake_case & camelCase ──
  -- e.g. `w` in `get_user_email` stops at u, e instead of jumping the whole identifier.
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", function() require("spider").motion("w") end, mode = { "n", "o", "x" }, desc = "Spider-w" },
      { "e", function() require("spider").motion("e") end, mode = { "n", "o", "x" }, desc = "Spider-e" },
      { "b", function() require("spider").motion("b") end, mode = { "n", "o", "x" }, desc = "Spider-b" },
    },
    opts = { skipInsignificantPunctuation = true },
  },

  -- ── Flash: label-based motion (replaces leap). `s` to jump, `S` for treesitter scopes. ──
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { jump_labels = true },
        search = { enabled = false }, -- don't hijack `/` — keep search ergonomics
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- ── Smart-splits: directional move/resize/swap across nvim splits ──
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-h>",      function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split" },
      { "<C-j>",      function() require("smart-splits").move_cursor_down() end,  desc = "Move to below split" },
      { "<C-k>",      function() require("smart-splits").move_cursor_up() end,    desc = "Move to above split" },
      { "<C-l>",      function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
      { "<A-h>",      function() require("smart-splits").resize_left() end,       desc = "Resize split left" },
      { "<A-j>",      function() require("smart-splits").resize_down() end,       desc = "Resize split down" },
      { "<A-k>",      function() require("smart-splits").resize_up() end,         desc = "Resize split up" },
      { "<A-l>",      function() require("smart-splits").resize_right() end,      desc = "Resize split right" },
      { "<leader>wh", function() require("smart-splits").swap_buf_left() end,     desc = "Swap split left" },
      { "<leader>wj", function() require("smart-splits").swap_buf_down() end,     desc = "Swap split down" },
      { "<leader>wk", function() require("smart-splits").swap_buf_up() end,       desc = "Swap split up" },
      { "<leader>wl", function() require("smart-splits").swap_buf_right() end,    desc = "Swap split right" },
    },
  },

  -- ── Treesitter-context: sticky scope header (extra-enabled; opts override) ──
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 4,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
    },
    keys = {
      { "<leader>uX", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter-context" },
      { "<leader>uo", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Jump to outer context" },
    },
  },

  -- ── Snacks scratch: markdown scratchpad with persistent root ──
  {
    "folke/snacks.nvim",
    opts = {
      scratch = {
        ft = "markdown",
        root = vim.fn.stdpath("data") .. "/scratch",
        autowrite = true,
      },
    },
    keys = {
      { "<leader>.",  function() require("snacks").scratch() end,        desc = "Toggle scratch buffer" },
      { "<leader>S",  function() require("snacks").scratch.select() end, desc = "Pick scratch buffer" },
    },
  },

  -- ── Inline image rendering in markdown (kitty/ghostty supported) ──
  {
    "3rd/image.nvim",
    ft = { "markdown" },
    enabled = function()
      local term = os.getenv("TERM") or ""
      return term:match("kitty") or term:match("ghostty") or os.getenv("KITTY_WINDOW_ID") ~= nil
    end,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = false,
          only_render_image_at_cursor = false,
          filetypes = { "markdown" },
        },
      },
      max_width_window_percentage = 60,
      max_height_window_percentage = 50,
    },
  },

  -- ── Markdown table-mode: pipe-aligned tables for docs editing ──
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    cmd = { "TableModeToggle", "TableModeEnable", "TableModeDisable" },
    keys = {
      { "<leader>mt", "<cmd>TableModeToggle<cr>", ft = "markdown", desc = "Markdown: toggle table mode" },
    },
    init = function()
      vim.g.table_mode_corner = "|" -- markdown-compatible corner
    end,
  },
}
