-- Java/Spring deepening on top of LazyVim's lang.java extra.
-- nvim-jdtls is already pulled in by the extra; here we:
--   • merge in java-debug + java-test bundles (DAP + JUnit runner)
--   • auto-inject lombok agent if ~/.local/share/lombok/lombok.jar exists
--   • tune jdtls settings (import order, formatter, organize-imports)
--   • bind buffer-local <leader>t{j,J,D} for junit and <leader>c{o,v,c,m} for refactor

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts = opts or {}
      local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages"

      -- ── Bundles for DAP + JUnit ─────────────────────────────
      local bundles = {}
      local jdebug = vim.fn.glob(mason_pkg .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
      if jdebug ~= "" then
        table.insert(bundles, jdebug)
      end
      local jtest = vim.fn.glob(mason_pkg .. "/java-test/extension/server/*.jar", true, true)
      if type(jtest) == "table" then
        vim.list_extend(bundles, jtest)
      end
      opts.dap = vim.tbl_deep_extend("force", opts.dap or {}, {
        hotcodereplace = "auto",
        config_overrides = {},
      })
      opts.dap_main = {}
      opts.test = true
      opts.jdtls = opts.jdtls or {}
      opts.jdtls.bundles = bundles

      -- ── Lombok agent ────────────────────────────────────────
      local lombok = vim.fn.expand("~/.local/share/lombok/lombok.jar")
      if vim.uv.fs_stat(lombok) then
        opts.cmd = opts.cmd or {}
        table.insert(opts.cmd, "--jvm-arg=-javaagent:" .. lombok)
      end

      -- ── Settings tuning ─────────────────────────────────────
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          eclipse = { downloadSources = true },
          maven = { downloadSources = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          references = { includeDecompiledSources = true },
          inlayHints = { parameterNames = { enabled = "all" } },
          format = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.junit.jupiter.api.Assumptions.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
            },
            importOrder = { "java", "javax", "com", "org" },
          },
          sources = {
            organizeImports = { starThreshold = 99, staticStarThreshold = 99 },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
      })

      return opts
    end,
  },

  -- ── Buffer-local Java keymaps via FileType autocmd ──
  {
    "mfussenegger/nvim-jdtls",
    init = function()
      local grp = vim.api.nvim_create_augroup("JavaKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "java",
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end
          local jdtls = function() return require("jdtls") end
          map("<leader>tj", function() jdtls().test_nearest_method() end, "JUnit: nearest")
          map("<leader>tJ", function() jdtls().test_class() end,           "JUnit: class")
          map("<leader>tD", function() jdtls().pick_test() end,             "JUnit: pick test")
          map("<leader>co", function() jdtls().organize_imports() end,      "Java: organize imports")
          map("<leader>cv", function() jdtls().extract_variable() end,      "Java: extract variable")
          map("<leader>cc", function() jdtls().extract_constant() end,      "Java: extract constant")
          map("<leader>cm", function() jdtls().extract_method(true) end,    "Java: extract method")
          vim.keymap.set("v", "<leader>cv", function() require("jdtls").extract_variable(true) end, { buffer = buf, desc = "Java: extract variable (sel)" })
          vim.keymap.set("v", "<leader>cm", function() require("jdtls").extract_method(true) end,   { buffer = buf, desc = "Java: extract method (sel)" })
        end,
      })
    end,
  },
}
