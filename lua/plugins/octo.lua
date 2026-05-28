-- Octo: GitHub PR/issue review inside nvim. Requires `gh` auth on disk.
-- Uses snacks.picker (already shipped with LazyVim) — no telescope dep.

return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      default_remote = { "upstream", "origin" },
      default_merge_method = "squash",
      picker = "snacks",
      ssh_aliases = {},
      timeout = 5000,
      mappings_disable_default = false,
    },
    keys = {
      { "<leader>gp", "<cmd>Octo pr list<cr>",         desc = "Octo: PR list" },
      { "<leader>gP", "<cmd>Octo pr search<cr>",       desc = "Octo: PR search" },
      { "<leader>gi", "<cmd>Octo issue list<cr>",      desc = "Octo: issues" },
      { "<leader>gr", "<cmd>Octo review start<cr>",    desc = "Octo: start review" },
      { "<leader>gR", "<cmd>Octo review submit<cr>",   desc = "Octo: submit review" },
      { "<leader>go", "<cmd>Octo<cr>",                 desc = "Octo: action palette" },
    },
  },
}
