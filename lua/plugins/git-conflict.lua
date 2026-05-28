-- git-conflict: 3-way merge resolution UX. Highlights ours/theirs/base blocks
-- and provides keymaps to pick a side. Bound under <leader>gc (conflict).

return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>",   desc = "Conflict: ours" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Conflict: theirs" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>",   desc = "Conflict: both" },
      { "<leader>gcn", "<cmd>GitConflictChooseNone<cr>",   desc = "Conflict: none" },
      { "<leader>gcl", "<cmd>GitConflictListQf<cr>",       desc = "Conflict: list" },
      { "]x",          "<cmd>GitConflictNextConflict<cr>", desc = "Next conflict" },
      { "[x",          "<cmd>GitConflictPrevConflict<cr>", desc = "Prev conflict" },
    },
  },
}
