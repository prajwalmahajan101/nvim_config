-- rainbow-delimiters: nested bracket coloring (treesitter-driven).
-- Lazy-load on supported filetypes only — skip markdown to avoid noise.

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rd.strategy["global"],
          vim = rd.strategy["local"],
          markdown = rd.strategy["none"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          javascript = "rainbow-delimiters-react",
          tsx = "rainbow-delimiters-react",
        },
        priority = { [""] = 110, lua = 210 },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}
