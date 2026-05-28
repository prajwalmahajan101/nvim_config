-- LuaSnip extension: friendly-snippets baseline + custom per-language libraries.
-- mini-snippets is disabled in lazyvim.json so luasnip is the single source of truth.
--
-- Custom snippets live in ~/.config/nvim/snippets/<filetype>/*.lua and are
-- hot-reloaded on save by luasnip.loaders.from_lua.

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- Selective load: only languages we actually edit, skipping noisy grab-bags
          -- (cpp, swift, latex, etc). Keeps completion menu relevant.
          require("luasnip.loaders.from_vscode").lazy_load({
            include = {
              "python", "javascript", "typescript", "typescriptreact", "javascriptreact",
              "go", "java", "lua", "bash", "sh", "zsh",
              "html", "css", "scss",
              "json", "yaml", "toml", "markdown",
              "dockerfile", "terraform", "make",
              "sql", "gitcommit", "vim",
            },
          })
        end,
      },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.history = true
      opts.update_events = "TextChanged,TextChangedI"
      opts.delete_check_events = "TextChanged"
      opts.region_check_events = "CursorMoved"
      opts.enable_autosnippets = true
      return opts
    end,
    keys = {
      -- Jump forward/back inside an active snippet placeholder. Outside a
      -- snippet, these keys fall through to their normal meaning (so
      -- blink.cmp super-tab ghost-text accept still works at the menu).
      {
        "<Tab>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then ls.expand_or_jump() else return "<Tab>" end
        end,
        mode = { "i", "s" },
        expr = true,
        silent = true,
      },
      {
        "<S-Tab>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then ls.jump(-1) else return "<S-Tab>" end
        end,
        mode = { "i", "s" },
        expr = true,
        silent = true,
      },
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup(opts)

      -- Custom Lua-DSL snippet libraries (per-filetype dirs).
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })

      -- Reload snippets on save without restarting nvim.
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = vim.fn.stdpath("config") .. "/snippets/**/*.lua",
        callback = function()
          require("luasnip.loaders.from_lua").load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
          vim.notify("Snippets reloaded", vim.log.levels.INFO, { title = "LuaSnip" })
        end,
      })
    end,
  },
}
