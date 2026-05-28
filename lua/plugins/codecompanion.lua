-- codecompanion: inline AI edits + multi-provider chat.
-- Complements claudecode.nvim (ai.lua) which owns <leader>a{c,f,r,C,m,b,s,a,d}.
-- Takes only <leader>a{I,A,P}. Silently no-ops if no API key present.

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionToggle" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
            schema = {
              model = { default = "claude-3-5-sonnet-20241022" },
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = { default = "qwen2.5-coder:latest" },
            },
          })
        end,
      },
      strategies = {
        chat   = { adapter = (os.getenv("ANTHROPIC_API_KEY") and "anthropic") or "ollama" },
        inline = { adapter = (os.getenv("ANTHROPIC_API_KEY") and "anthropic") or "ollama" },
        cmd    = { adapter = (os.getenv("ANTHROPIC_API_KEY") and "anthropic") or "ollama" },
      },
      display = {
        chat = {
          window = { layout = "vertical", width = 0.40, height = 0.85, border = "rounded" },
          show_settings = false,
          show_token_count = true,
        },
        inline = {
          layout = "vertical",
          diff = { enabled = true },
        },
        action_palette = {
          provider = "default",
          opts = { show_default_actions = true, show_default_prompt_library = true },
        },
      },
      opts = {
        log_level = "ERROR",
        send_code = true,
        use_default_actions = true,
        use_default_prompt_library = true,
      },
    },
    keys = {
      { "<leader>aI", "<cmd>CodeCompanion<cr>",        mode = { "n", "v" }, desc = "CodeCompanion: inline edit" },
      { "<leader>aA", "<cmd>CodeCompanionChat<cr>",    mode = { "n", "v" }, desc = "CodeCompanion: chat toggle" },
      { "<leader>aP", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: action palette" },
    },
  },
}
