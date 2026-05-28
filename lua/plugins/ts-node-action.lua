-- ts-node-action: AST mutations under the cursor.
-- Examples: toggle ternary↔if-else, expand object literal, flip booleans,
-- split long arg lists into multiline, sort imports.

return {
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<leader>cA", function() require("ts-node-action").node_action() end, desc = "AST: action under cursor" },
    },
    opts = {},
  },
}
