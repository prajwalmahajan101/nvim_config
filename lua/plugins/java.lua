-- Java/Spring deepening on top of LazyVim's lang.java extra.
-- nvim-jdtls is already pulled in by the extra; here we:
--   • resolve JAVA_HOME to a real JDK (bypassing mise shims that break -D args)
--   • merge in java-debug + java-test bundles (DAP + JUnit runner)
--   • auto-inject lombok agent if ~/.local/share/lombok/lombok.jar exists
--   • tune jdtls settings (import order, formatter, organize-imports)
--   • bind buffer-local <leader>t{j,J,D} for junit and <leader>c{o,v,c,m} for refactor

-- ── Resolve a non-mise-shimmed Java path ─────────────────────────────────
-- jdtls.py launches `java -Djdk.xml.maxGeneralEntitySizeLimit=0 ...`. If `java`
-- in PATH is a mise shim, mise treats the -D arg as a tool name and aborts.
-- jdtls.py prefers $JAVA_HOME/bin/java when set, so we point it at the real
-- mise install (or any other JDK we can find) before the LSP starts.
local function resolve_java_home()
  if vim.env.JAVA_HOME and vim.uv.fs_stat(vim.env.JAVA_HOME .. "/bin/java") then
    return vim.env.JAVA_HOME -- user already set it; respect it
  end
  -- 1) Ask mise (fast, authoritative if mise manages java).
  local ok, mise = pcall(vim.fn.system, "mise which java 2>/dev/null")
  if ok and type(mise) == "string" and mise ~= "" then
    mise = vim.trim(mise)
    if vim.uv.fs_stat(mise) then
      -- mise prints path to .../bin/java; JAVA_HOME is two parents up.
      return vim.fn.fnamemodify(mise, ":h:h")
    end
  end
  -- 2) Common system locations.
  for _, candidate in ipairs({
    "/usr/lib/jvm/default",
    "/usr/lib/jvm/java-21-openjdk",
    "/usr/lib/jvm/java-17-openjdk",
  }) do
    if vim.uv.fs_stat(candidate .. "/bin/java") then return candidate end
  end
  return nil
end

local jh = resolve_java_home()
if jh then vim.env.JAVA_HOME = jh end

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
