-- Fidget: compact bottom-right LSP progress (basedpyright analyzing, gopls etc).
-- Noice handles cmdline/messages; fidget handles progress only.

return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          progress_icon = { pattern = "dots", period = 1 },
          done_icon = " ",
          render_limit = 8,
        },
        suppress_on_insert = true,
        ignore_done_already = false,
        ignore_empty_message = true,
        poll_rate = 0,
      },
      notification = {
        window = {
          winblend = 0,
          border = "none",
          align = "bottom",
          relative = "editor",
        },
        view = { stack_upwards = true, group_separator = "─" },
      },
    },
  },
}
