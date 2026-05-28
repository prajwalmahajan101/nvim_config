-- Undotree: graph of undo history (Mercurial-style) with diff preview.

return {
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeFocus" },
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2          -- tree right, diff bottom
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_HelpLine = 0
      vim.g.undotree_SplitWidth = 32
      vim.g.undotree_DiffpanelHeight = 12
    end,
  },
}
