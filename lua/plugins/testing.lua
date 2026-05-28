-- Neotest: unified test runner UI.
-- Adapters for Python (pytest) and Go come from lang.python + lang.go extras;
-- this file consolidates them, picks runners, and wires <leader>t… keys.

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            runner = "pytest",
            dap = { justMyCode = false },
            args = { "--log-level=INFO" },
          }),
          require("neotest-golang")({
            go_test_args = { "-v", "-race", "-count=1" },
            dap_go_enabled = true,
          }),
        },
        discovery = { enabled = true, concurrent = 1 },
        running = { concurrent = true },
        status = { virtual_text = true, signs = true },
        output = { open_on_run = false },
        output_panel = { open = "botright split | resize 15" },
        quickfix = { enabled = false, open = false },
        summary = {
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            jumpto = "i",
            output = "o",
            run = "r",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        icons = {
          passed = " ",
          failed = " ",
          running = " ",
          skipped = "󰒬 ",
          unknown = " ",
        },
      }
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                                desc = "Run nearest test" },
      { "<leader>tT", function() require("neotest").run.run(vim.fn.expand("%")) end,             desc = "Run file" },
      { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end,                   desc = "Run all (cwd)" },
      { "<leader>tr", function() require("neotest").run.run_last() end,                          desc = "Run last" },
      { "<leader>tl", function() require("neotest").run.run_last() end,                          desc = "Run last (alias)" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,           desc = "Debug nearest (DAP)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                        desc = "Summary panel" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Output (float)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                   desc = "Output panel" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,        desc = "Watch file" },
      { "<leader>tS", function() require("neotest").run.stop() end,                              desc = "Stop" },
    },
  },

  -- Line-gutter coverage signs (opt-in, lazy on command)
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageLoad", "CoverageShow", "CoverageToggle", "CoverageSummary" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      auto_reload = true,
      lang = {
        python = { coverage_command = "coverage json -q -o -" },
        go = { coverage_file = "coverage.out" },
      },
    },
    keys = {
      { "<leader>tc", "<cmd>CoverageToggle<cr>", desc = "Toggle coverage" },
      { "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
    },
  },
}
