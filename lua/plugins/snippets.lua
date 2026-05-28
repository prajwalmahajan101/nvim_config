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
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.history = true
      opts.update_events = "TextChanged,TextChangedI"
      opts.delete_check_events = "TextChanged"
      return opts
    end,
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
