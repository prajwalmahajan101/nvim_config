-- Kulala polish layered on top of the lazyvim.plugins.extras.util.rest extra.
-- The extra already declares the plugin spec, ft trigger, and a baseline
-- <leader>R… keymap set (Rs=send, Rr=replay, Rc=copy curl, Re=env, Rt=view, etc).
-- Here we only:
--   • override opts (default env, view, content-type formatters)
--   • add `.rest` filetype alongside `.http`
--   • add a couple of extra keymaps not in the upstream extra

return {
  {
    "mistweaverco/kulala.nvim",
    -- Pre-build the kulala_http tree-sitter parser so first .http open
    -- doesn't fail with "Parser could not be created" while kulala's async
    -- build runs. Requires `tree-sitter` CLI in PATH.
    build = function()
      local plugin_dir  = vim.fn.stdpath("data") .. "/lazy/kulala.nvim/lua/tree-sitter"
      local parsers_dir = vim.fn.stdpath("data") .. "/site/parser"
      local queries_src = plugin_dir .. "/queries/kulala_http"
      local queries_dst = vim.fn.stdpath("data") .. "/site/queries/kulala_http"
      vim.fn.mkdir(parsers_dir, "p")
      vim.fn.mkdir(queries_dst, "p")
      pcall(vim.fn.system, { "cp", "-rT", queries_src, queries_dst })
      local out = vim.fn.shellescape(parsers_dir .. "/kulala_http.so")
      vim.fn.system("cd " .. vim.fn.shellescape(plugin_dir) .. " && tree-sitter build -o " .. out)
    end,
    opts = function(_, opts)
      opts.default_view = "body"
      opts.default_env  = "dev"
      opts.winbar       = true
      opts.show_icons   = "on_request"
      opts.debug        = false
      opts.icons = vim.tbl_deep_extend("force", opts.icons or {}, {
        inlay   = { loading = "󰔟", done = " ", error = " " },
        lualine = "󰈎",
      })
      opts.contenttypes = vim.tbl_deep_extend("force", opts.contenttypes or {}, {
        ["application/json"] = { ft = "json", formatter = { "jq", "." } },
        ["application/xml"]  = { ft = "xml",  formatter = { "xmllint", "--format", "-" } },
        ["text/html"]        = { ft = "html", formatter = { "prettier", "--parser", "html" } },
      })
      return opts
    end,
    init = function()
      vim.filetype.add({ extension = { ["rest"] = "http" } })
    end,
    keys = {
      { "<leader>Ra", function() require("kulala").run_all() end,   desc = "Run all requests", ft = "http" },
      { "<leader>R.", function() require("kulala").jump_next() end, desc = "Next request",     ft = "http" },
      { "<leader>R,", function() require("kulala").jump_prev() end, desc = "Prev request",     ft = "http" },
    },
  },
}
