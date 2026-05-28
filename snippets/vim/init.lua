-- Vim/Lua snippets for editing nvim config: lazy.nvim plugin specs, augroup autocmds.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("vim_plugin_spec", fmt([[
{{
  "{repo}",
  {trigger}
  opts = {{
    {opts}
  }},
}},
]], { repo = i(1, "author/plugin.nvim"), trigger = i(2, "event = \"VeryLazy\","), opts = i(3, "") })),

  s("vim_autocmd", fmt([[
vim.api.nvim_create_autocmd("{event}", {{
  group = vim.api.nvim_create_augroup("{group}", {{ clear = true }}),
  pattern = {pattern},
  callback = function({args})
    {body}
  end,
}})
]], {
    event = i(1, "FileType"),
    group = i(2, "MyGroup"),
    pattern = i(3, "{ \"lua\" }"),
    args = i(4, "args"),
    body = i(5, "-- ..."),
  })),

  s("vim_keymap", fmt([[
vim.keymap.set({mode}, "{lhs}", {rhs}, {{ desc = "{desc}" }})
]], { mode = i(1, "\"n\""), lhs = i(2, "<leader>x"), rhs = i(3, "function() end"), desc = i(4, "...") })),

  s("vim_setup", fmt([[
return {{
  {{
    "{repo}",
    {trigger}
    opts = function(_, opts)
      {body}
      return opts
    end,
  }},
}}
]], { repo = i(1, "author/plugin"), trigger = i(2, "event = \"VeryLazy\","), body = i(3, "opts = opts or {}") })),
}
