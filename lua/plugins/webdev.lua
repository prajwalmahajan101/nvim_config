-- Web dev tools for Django / FastAPI / Spring Boot / Next.js stacks:
--   • kulala.nvim   — HTTP/REST client (.http files; Postman in your editor)
--   • vim-dadbod   — universal database client (DBeaver in your editor)

-- Note: lazyvim.plugins.extras.util.rest is declared in ../../lazyvim.json so
-- LazyVim auto-imports it in the correct spec order.

return {
  -- ── Database client ──────────────────────────────────────
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
    init = function()
      -- Persist connections + UI prefs
      vim.g.db_ui_save_location  = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40
    end,
    keys = {
      { "<leader>D",  "",                  desc = "+database" },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
  },
  -- Completion for SQL buffers (omnicomp + blink integration)
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = { "tpope/vim-dadbod" },
  },

  -- Treesitter parser for HTTP request files (kulala uses `http` ft)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http" })
    end,
  },
}
