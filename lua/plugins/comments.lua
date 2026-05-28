-- Fixes the ts_context_commentstring nil-language_tree crash by replacing the
-- legacy stack (mini.comment + nvim-ts-context-commentstring) with ts-comments.nvim
-- over Neovim's native gc operator (built-in since 0.10).

return {
  -- Modern replacement: tiny wrapper over native gc + treesitter commentstring
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
    opts = {},
  },

  -- Belt-and-suspenders: the coding.mini-comment extra is no longer enabled in
  -- lazyvim.json, but keep these disabled so the legacy stack can't sneak back
  -- in as a transitive dependency and re-introduce the nil-tree crash.
  { "nvim-mini/mini.comment", enabled = false },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },

  -- Auto-install treesitter parsers for any opened filetype so the
  -- treesitter-aware commentstring lookup never hits a nil tree again.
  -- (The explicit parser list lives in langs.lua — the single source of truth.)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.auto_install = true
    end,
  },
}
