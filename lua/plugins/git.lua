-- Git power-ups beyond LazyVim defaults.
-- Lazygit (<leader>gg / <leader>gG) is already wired by LazyVim core.
-- Gitsigns (<leader>gh… for hunks) is already a LazyVim default.
--
-- This file adds:
--   • diffview.nvim — file history (<leader>gh) + 3-pane PR-style diffs (<leader>gd)
--   • gitlinker    — copy github.com URL for the current line/range (<leader>gy)

return {
  -- ── Diffview: file history + 3-pane diffs ─────────────
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",         desc = "Diff against index" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>",  desc = "Diff against HEAD~1" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",  desc = "Repo file history" },
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>",        desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
      file_panel = { listing_style = "tree" },
    },
  },

  -- ── Gitlinker: copy github URLs to current line/range ──
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gy",
        function() require("gitlinker").get_buf_range_url("n") end,
        mode = "n",
        desc = "Copy git permalink (line)",
        silent = true,
      },
      { "<leader>gy",
        function() require("gitlinker").get_buf_range_url("v") end,
        mode = "v",
        desc = "Copy git permalink (range)",
        silent = true,
      },
      { "<leader>gO",
        function() require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser }) end,
        desc = "Open repo in browser",
        silent = true,
      },
    },
    config = function()
      require("gitlinker").setup({
        opts = { add_current_line_on_normal_mode = true, print_url = true },
      })
    end,
  },
}
