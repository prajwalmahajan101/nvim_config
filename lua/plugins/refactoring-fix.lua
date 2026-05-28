-- LazyVim's editor.refactoring extra loads the bundled telescope extension,
-- but upstream refactoring.nvim removed `lua/telescope/_extensions/refactoring.lua`,
-- so the LazyLoad autocmd crashes on startup.
--
-- Override `config` to call setup() directly and skip the telescope hookup.
-- The refactor picker now goes through `vim.ui.select`, which snacks picker
-- already provides via LazyVim's defaults — same UX, no missing module.

return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
    end,
    keys = {
      {
        "<leader>rs",
        function() require("refactoring").select_refactor() end,
        mode = { "n", "x" },
        desc = "Refactor (select)",
      },
    },
  },
}
