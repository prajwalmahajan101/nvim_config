-- direnv.vim: auto-load .envrc when entering a project that uses direnv.
-- Silent so it doesn't spam messages every cd.

return {
  {
    "direnv/direnv.vim",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.direnv_silent_load = 1
      vim.g.direnv_auto = 1
    end,
  },
}
