-- csvview: column-aligned display for CSV/TSV/PSV files.
-- Useful for inspecting API response dumps and tabular data.

return {
  {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv", "psv" },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    opts = {
      parser = { comments = { "#", "//" } },
      view = {
        display_mode = "border",
        header_lnum = 1,
        spacing = 2,
      },
    },
    config = function(_, opts)
      require("csvview").setup(opts)
    end,
    keys = {
      { "<leader>uV", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV view" },
    },
  },
}
