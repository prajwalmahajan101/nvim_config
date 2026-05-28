-- lsp_lines: multi-line diagnostic display, toggled with <leader>uD.
-- Default: disabled (existing virtual_text from ui.lua stays on).

return {
  {
    "maan2003/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = false })
    end,
    keys = {
      {
        "<leader>uD",
        function()
          local cfg = vim.diagnostic.config() or {}
          if cfg.virtual_lines then
            vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
            vim.notify("Diagnostics: virtual_text", vim.log.levels.INFO)
          else
            vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
            vim.notify("Diagnostics: virtual_lines (multi-line)", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle diagnostic display (lines/text)",
      },
    },
  },
}
