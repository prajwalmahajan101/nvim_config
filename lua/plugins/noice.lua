-- Noice: floating cmdline + LSP hover/signature override + message routing.
-- Snacks.notifier handles transient notifications; noice owns cmdline/messages
-- only — `notifier = { enabled = false }` is set inside noice.routes to keep
-- the two from doubling up.

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline     = { icon = " " },
          search_down = { icon = "  " },
          search_up   = { icon = "  " },
          filter      = { icon = " " },
          lua         = { icon = " " },
          help        = { icon = " " },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true, silent = true },
        signature = { enabled = true, auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 50 } },
        message = { enabled = true, view = "notify" },
        progress = { enabled = false }, -- fidget owns this
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        -- Skip "written" and "search hit" — noisy, redundant.
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        { filter = { event = "msg_show", kind = "search_count" },       opts = { skip = true } },
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = { winhighlight = { Normal = "Normal", FloatBorder = "FloatBorder" } },
        },
      },
    },
    keys = {
      { "<leader>n",  "",                                                     desc = "+notice" },
      { "<leader>nl", function() require("noice").cmd("last") end,            desc = "Last message" },
      { "<leader>nh", function() require("noice").cmd("history") end,         desc = "History" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end,         desc = "Dismiss all" },
      { "<leader>na", function() require("noice").cmd("all") end,             desc = "All messages" },
      { "<leader>ne", function() require("noice").cmd("errors") end,          desc = "Errors" },
      { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<c-f>",      function() if not require("noice.lsp").scroll(4)  then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward",  mode = { "i", "n", "s" } },
      { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
    },
  },

  -- Snacks notifier stays on for transient toasts; just keep its priority lower
  -- so noice doesn't fight it.
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = true, top_down = false, timeout = 2500 },
    },
  },
}
