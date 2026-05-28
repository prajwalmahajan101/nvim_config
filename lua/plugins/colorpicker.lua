-- ccc.nvim: HSL/HEX/RGB color picker + inline color preview highlights.

return {
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle", "CccHighlighterEnable", "CccHighlighterDisable" },
    keys = {
      { "<leader>uC", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle inline colors" },
      { "<leader>cP", "<cmd>CccPick<cr>",              desc = "Pick color (CCC)" },
    },
    opts = function()
      local ccc = require("ccc")
      return {
        highlighter = {
          auto_enable = true,
          lsp = true,
          filetypes = { "css", "scss", "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua", "vim", "conf", "yaml", "toml", "ini" },
          excludes = { "lazy", "mason", "help" },
        },
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_oklch,
        },
        outputs = {
          ccc.output.hex,
          ccc.output.css_rgb,
          ccc.output.css_hsl,
          ccc.output.css_oklch,
        },
      }
    end,
  },
}
