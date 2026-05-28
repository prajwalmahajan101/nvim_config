-- Hardtime: nudge toward efficient motions. Hint mode (not block) — gentle.

return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      enabled = true,
      disable_mouse = false,
      max_count = 4,
      restriction_mode = "hint",
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n", "x" },
        ["k"] = { "n", "x" },
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<CR>"] = { "n", "x" },
        ["<C-M>"] = { "n", "x" },
        ["<C-N>"] = { "n", "x" },
        ["<C-P>"] = { "n", "x" },
      },
      disabled_keys = {
        ["<Up>"]    = { "n" },
        ["<Down>"]  = { "n" },
        ["<Left>"]  = { "n" },
        ["<Right>"] = { "n" },
      },
      disabled_filetypes = {
        "qf", "netrw", "neo-tree", "lazy", "mason", "snacks_dashboard",
        "alpha", "TelescopePrompt", "oil", "Outline", "trouble",
        "dap-repl", "dapui_scopes", "dapui_breakpoints", "dapui_stacks",
        "dapui_watches", "dapui_console", "noice", "notify", "help",
        "checkhealth", "lspinfo", "lazyterm", "toggleterm", "snacks_picker_list",
      },
      hint = true,
      notification = true,
      allow_different_key = true,
    },
    keys = {
      { "<leader>uH", "<cmd>Hardtime toggle<cr>", desc = "Toggle hardtime" },
    },
  },
}
