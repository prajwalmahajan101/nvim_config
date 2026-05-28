-- Documentation rendering polish: headlines, glance (LSP peek), devicon tweaks.

return {
  -- ── headlines: tinted backgrounds for #/## and fenced code blocks ──
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
        bullets = { "◉", "○", "✸", "✿" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        quote_highlight = "Quote",
        fat_headlines = true,
        fat_headline_upper_string = "▃",
        fat_headline_lower_string = "🬂",
      },
    },
    config = function(_, opts)
      vim.schedule(function()
        local set_hl = function(name, fg, bg)
          local ok = pcall(vim.api.nvim_set_hl, 0, name, { fg = fg, bg = bg, default = true })
          if not ok then return end
        end
        set_hl("Headline1", "#bb9af7", "#2d2a4e")
        set_hl("Headline2", "#7aa2f7", "#1f2335")
        set_hl("Headline3", "#7dcfff", "#1f2335")
        set_hl("Headline4", "#9ece6a", "#1f2335")
        set_hl("Headline5", "#e0af68", "#1f2335")
        set_hl("Headline6", "#f7768e", "#1f2335")
        set_hl("CodeBlock", nil, "#1a1b26")
        require("headlines").setup(opts)
      end)
    end,
  },

  -- ── glance: floating peek window for def/refs/typeDef/impl ──
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      height = 18,
      border = { enable = true, top_char = "─", bottom_char = "─" },
      list = { position = "right", width = 0.33 },
      preview_win_opts = { cursorline = true, number = true, wrap = false },
      theme = { enable = true, mode = "auto" },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then jump(results[1]) else open(results) end
        end,
      },
    },
    keys = {
      { "<leader>cpd", "<cmd>Glance definitions<cr>",      desc = "Peek definition" },
      { "<leader>cpr", "<cmd>Glance references<cr>",      desc = "Peek references" },
      { "<leader>cpD", "<cmd>Glance type_definitions<cr>", desc = "Peek type def" },
      { "<leader>cpi", "<cmd>Glance implementations<cr>", desc = "Peek implementations" },
    },
  },

  -- ── devicons: add a couple of file types ──
  {
    "nvim-tree/nvim-web-devicons",
    opts = function(_, opts)
      opts.override = opts.override or {}
      opts.override["http"] = { icon = "󰖟", color = "#7aa2f7", name = "Http" }
      opts.override["rest"] = { icon = "󰖟", color = "#7aa2f7", name = "Rest" }
      opts.override["envrc"] = { icon = "", color = "#9ece6a", name = "Envrc" }
      opts.override_by_filename = opts.override_by_filename or {}
      opts.override_by_filename[".env"] = { icon = "", color = "#e0af68", name = "Env" }
      opts.override_by_filename["docker-compose.yml"] = { icon = "󰡨", color = "#519aba", name = "DockerCompose" }
      return opts
    end,
  },
}
