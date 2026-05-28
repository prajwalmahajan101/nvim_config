-- Session persistence: auto-restore per-cwd state (buffers, windows, tabs).

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = function()
        -- Drop transient buffers from the session.
        local drop = { "alpha", "lazy", "mason", "TelescopePrompt", "trouble", "notify",
                       "snacks_dashboard", "Outline", "neo-tree", "qf", "dap-repl" }
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if vim.tbl_contains(drop, ft) then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end,
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                   desc = "Restore session (cwd)" },
      { "<leader>qS", function() require("persistence").select() end,                 desc = "Select session" },
      { "<leader>qL", function() require("persistence").load({ last = true }) end,    desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                   desc = "Don't save current session" },
    },
  },
}
