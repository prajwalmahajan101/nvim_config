-- Sniprun: inline code execution for snippets / REPL-style exploration.
-- Built binary is required; `sh install.sh` fetches a prebuilt release.

return {
  {
    "michaelb/sniprun",
    build = "sh install.sh",
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive", "SnipTerminate" },
    opts = {
      display = { "VirtualTextOk", "TempFloatingWindow" },
      live_display = { "VirtualTextOk" },
      display_options = {
        terminal_width = 45,
        notification_timeout = 5,
      },
      show_no_output = { "Classic", "TempFloatingWindow" },
      snipruncolors = {
        SniprunVirtualTextOk  = { fg = "#9ece6a", ctermfg = "Black", cterm = { bold = true } },
        SniprunVirtualTextErr = { fg = "#f7768e", ctermfg = "Black", cterm = { bold = true } },
      },
      live_mode_toggle = "off",
      borders = "rounded",
    },
    config = function(_, opts)
      require("sniprun").setup(opts)
    end,
    keys = {
      { "<leader>cx", "<cmd>SnipRun<cr>",          mode = "n", desc = "Run line (sniprun)" },
      { "<leader>cX", "<esc><cmd>SnipRun<cr>",     mode = "v", desc = "Run selection (sniprun)" },
      { "<leader>cQ", "<cmd>SnipClose<cr>",        desc = "Close sniprun output" },
      { "<leader>cI", "<cmd>SnipInfo<cr>",         desc = "Sniprun info" },
    },
  },
}
