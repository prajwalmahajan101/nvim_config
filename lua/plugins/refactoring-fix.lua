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
      { "<leader>rs", function() require("refactoring").select_refactor() end,                        mode = { "n", "x" }, desc = "Refactor (select)" },
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end,             mode = "x",          desc = "Extract function" },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function To File") end,     mode = "x",          desc = "Extract function to file" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end,             mode = "x",          desc = "Extract variable" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end,              mode = { "n", "x" }, desc = "Inline variable" },
      { "<leader>rI", function() require("refactoring").refactor("Inline Function") end,              mode = "n",          desc = "Inline function" },
      { "<leader>rb", function() require("refactoring").refactor("Extract Block") end,                mode = "n",          desc = "Extract block" },
      { "<leader>rB", function() require("refactoring").refactor("Extract Block To File") end,        mode = "n",          desc = "Extract block to file" },
      -- Debug print helpers
      { "<leader>rp", function() require("refactoring").debug.printf({ below = false }) end,          mode = "n",          desc = "Debug: printf" },
      { "<leader>rP", function() require("refactoring").debug.print_var() end,                        mode = { "n", "x" }, desc = "Debug: print var" },
      { "<leader>rd", function() require("refactoring").debug.cleanup({}) end,                        mode = "n",          desc = "Debug: cleanup prints" },
    },
  },
}
