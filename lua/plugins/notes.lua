-- Obsidian.nvim stub: disabled by default. Flip `enabled = true` and point
-- `workspaces[1].path` at your vault when you start using one.
return {
  {
    "epwalsh/obsidian.nvim",
    enabled = false,
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "vault", path = "~/notes" },
      },
      completion = { nvim_cmp = false, blink = true, min_chars = 2 },
      ui = { enable = false }, -- let render-markdown / image.nvim handle visuals
    },
  },
}
