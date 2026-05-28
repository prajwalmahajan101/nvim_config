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
    opts = {
      -- Per-language debug-print templates. {{cursor}} is the cursor position
      -- after expansion; {{var}} is the variable name picked from the cursor.
      printf_statements = {
        python = { 'print(f"[DEBUG] {{cursor}}")' },
        go     = { 'fmt.Println("[DEBUG] {{cursor}}")' },
        java   = { 'System.out.println("[DEBUG] {{cursor}}");' },
        typescript       = { 'console.log("[DEBUG] {{cursor}}")' },
        typescriptreact  = { 'console.log("[DEBUG] {{cursor}}")' },
        javascript       = { 'console.log("[DEBUG] {{cursor}}")' },
        javascriptreact  = { 'console.log("[DEBUG] {{cursor}}")' },
        lua    = { 'vim.print({ debug = "{{cursor}}" })' },
        sh     = { 'echo "[DEBUG] {{cursor}}" >&2' },
        bash   = { 'echo "[DEBUG] {{cursor}}" >&2' },
      },
      print_var_statements = {
        python = { 'print(f"[DEBUG] {{var}}={{ {{var}}!r }}")' },
        go     = { 'fmt.Printf("[DEBUG] {{var}}=%+v\\n", {{var}})' },
        java   = { 'System.out.println("[DEBUG] {{var}} = " + {{var}});' },
        typescript       = { 'console.log("[DEBUG] {{var}} =", {{var}});' },
        typescriptreact  = { 'console.log("[DEBUG] {{var}} =", {{var}});' },
        javascript       = { 'console.log("[DEBUG] {{var}} =", {{var}});' },
        javascriptreact  = { 'console.log("[DEBUG] {{var}} =", {{var}});' },
        lua    = { 'vim.print({ {{var}} = {{var}} })' },
        sh     = { 'echo "[DEBUG] {{var}}=${{var}}" >&2' },
        bash   = { 'echo "[DEBUG] {{var}}=${{var}}" >&2' },
      },
      show_success_message = true,
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
