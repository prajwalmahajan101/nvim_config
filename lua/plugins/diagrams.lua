-- Diagram authoring support: Mermaid + PlantUML.
--   • mermaid    — treesitter parser ships with nvim-treesitter (added in
--                  langs.lua). render-markdown.nvim then syntax-highlights
--                  ```mermaid blocks inline.
--   • plantuml   — syntax + ftdetect via aklt/plantuml-syntax. Optional
--                  preview via weirongxu/plantuml-previewer (browser).

return {
  -- PlantUML: syntax + filetype detection for .puml / .plantuml / .iuml
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  },

  -- Live PlantUML preview in the browser (requires java + graphviz `dot`
  -- on $PATH; the plugin downloads plantuml.jar on first :PlantumlOpen).
  {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml" },
    dependencies = {
      "tyru/open-browser.vim",
      "aklt/plantuml-syntax",
    },
    keys = {
      { "<leader>cup", "<cmd>PlantumlOpen<cr>",  ft = "plantuml", desc = "PlantUML: open preview" },
      { "<leader>cuc", "<cmd>PlantumlSave<cr>",  ft = "plantuml", desc = "PlantUML: save PNG" },
    },
  },
}
