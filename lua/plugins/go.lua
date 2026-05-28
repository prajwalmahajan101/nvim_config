-- Go deepening: project tasks + struct tag editing + iferr scaffold.
-- LSP (gopls) is already configured in lsp-settings.lua → go.nvim's lsp_cfg=false.

return {
  -- ── go.nvim: project tasks (test, build, mod, run) ─────
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod", "gosum", "gowork" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false,
      lsp_keymaps = false,
      lsp_inlay_hints = { enable = false }, -- LazyVim's vim.lsp.inlay_hint owns this
      dap_debug = true,
      dap_debug_keymap = false,
      gofmt = "gofumpt",
      max_line_len = 120,
      icons = { breakpoint = "🛑", currentpos = "🏃" },
      luasnip = true,
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  -- ── gopher.nvim: struct tag editor + iferr + fillstruct ─
  {
    "olexsmir/gopher.nvim",
    ft = { "go" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    build = function()
      vim.cmd("GoInstallDeps")
    end,
    opts = {
      commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "gotests",
        impl = "impl",
        iferr = "iferr",
      },
      gotests_template = "",
      gotests_template_dir = "",
    },
  },

  -- ── Buffer-local Go keymaps via FileType autocmd ──
  {
    "ray-x/go.nvim",
    init = function()
      local grp = vim.api.nvim_create_augroup("GoKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "go",
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end
          map("<leader>cgi", "<cmd>GoIfErr<cr>",          "Go: iferr")
          map("<leader>cgt", "<cmd>GoAddTag<cr>",         "Go: add struct tags")
          map("<leader>cgT", "<cmd>GoRmTag<cr>",          "Go: remove struct tags")
          map("<leader>cgf", "<cmd>GoFillStruct<cr>",     "Go: fill struct")
          map("<leader>cgF", "<cmd>GoFillSwitch<cr>",     "Go: fill switch")
          map("<leader>cgr", "<cmd>GoRun<cr>",            "Go: run")
          map("<leader>cgb", "<cmd>GoBuild<cr>",          "Go: build")
          map("<leader>cgm", "<cmd>GoModTidy<cr>",        "Go: mod tidy")
          map("<leader>cgI", "<cmd>GoImpl<cr>",           "Go: impl interface")
          map("<leader>cgg", "<cmd>GoGenerate<cr>",       "Go: generate")
          map("<leader>cgc", "<cmd>GoCmt<cr>",            "Go: add comment")
          map("<leader>cge", "<cmd>GoIfErr<cr>",          "Go: iferr (alt)")
        end,
      })
    end,
  },
}
