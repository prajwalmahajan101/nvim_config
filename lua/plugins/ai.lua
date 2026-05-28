-- Claude AI integration via Coder's claudecode.nvim.
-- Spawns a Claude Code CLI session inside a terminal split, lets you send
-- the visual selection / current file as context, applies diffs back.
-- Uses your existing Claude Code subscription — no separate API key.
--
-- Default keymaps (under <leader>a):
--   <leader>ac  open / focus Claude Code in a split
--   <leader>af  send current file to Claude Code
--   <leader>as  (visual) send selection to Claude Code
--   <leader>aq  quit Claude Code
--   <leader>ar  resume previous Claude Code session
--   <leader>aC  start Claude Code in continue mode
--
-- Diff workflow:
--   When Claude proposes a change, it shows a diff inside nvim. Accept with
--   <leader>aa, reject with <leader>ad.

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" }, -- terminal split provider (already in LazyVim)
    config = true,
    keys = {
      { "<leader>a",  nil,                                                                desc = "+ai/claude" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",                                              desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",                                         desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",                                     desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",                                   desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",                                   desc = "Select Claude Model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",                                         desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",                            mode = "v",   desc = "Send selection" },
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",                                       desc = "Add file (neo-tree)", ft = { "NvimTree", "neo-tree", "oil" } },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",                                    desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",                                      desc = "Reject diff" },
    },
  },
}
