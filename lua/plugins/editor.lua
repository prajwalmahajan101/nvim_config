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
}
