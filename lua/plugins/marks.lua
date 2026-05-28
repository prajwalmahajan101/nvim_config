-- marks.nvim: visual mark labels in the signcolumn. m{a-z} sets, dm{a-z} deletes.

return {
  {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {
        "snacks_dashboard", "alpha", "neo-tree", "oil", "TelescopePrompt",
        "lazy", "mason", "Trouble", "trouble", "help", "noice", "notify",
        "dap-repl", "dapui_scopes", "dapui_watches", "dapui_stacks",
      },
      bookmark_0 = { sign = "⚑", virt_text = "todo", annotate = false },
      mappings = {
        delete_buf = "<leader>md",
        next = "]m",
        prev = "[m",
        preview = "<leader>mP",
        set_next = "m,",
        toggle = "m;",
      },
    },
  },
}
