-- Language extras tuned for the stack the user actually edits:
--   • Python (Django / FastAPI)
--   • JavaScript / TypeScript (React / Next.js)
--   • Java (Spring Boot)
--   • Go
--   • Markdown (docs)
--   • Lua is already configured by LazyVim core
--
-- All language/formatter/linter/editor extras for this stack (lang.python,
-- lang.typescript, lang.json, lang.go, lang.java, …) are declared in
-- ../../lazyvim.json so LazyVim auto-imports them in the correct order
-- (between lazyvim.plugins and user plugins). They are intentionally NOT
-- re-imported here — this file only *extends* their config (extra treesitter
-- parsers, conform formatters, Mason tools).

return {
  -- ── Treesitter parsers for the chosen language set ──────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<C-Space>",
          node_incremental  = "<C-Space>",
          scope_incremental = "<C-s>",
          node_decremental  = "<BS>",
        },
      }
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Python / Django / FastAPI
        "python", "htmldjango", "requirements", "ninja", "rst",
        -- JS / TS (API frontends, scripting)
        "javascript", "typescript", "tsx", "jsdoc", "css", "scss", "html",
        -- Java / Spring
        "java", "properties", "xml",
        -- Go
        "go", "gomod", "gosum", "gowork",
        -- Docs (markdown + diagram code-fences)
        "markdown", "markdown_inline", "mermaid",
        -- Lua / config
        "lua", "luadoc", "luap",
        -- Shell / data
        "bash", "fish", "json", "yaml", "toml",
        -- Git
        "diff", "gitignore", "gitcommit", "git_rebase", "gitattributes",
        -- Editor internals / systems (formerly listed in comments.lua)
        "vim", "vimdoc", "query", "c", "cpp", "rust",
        -- Misc
        "regex", "dockerfile", "sql", "make", "dot",
      })
    end,
  },

  -- ── Conform: per-language formatters used by format-on-save ────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- ruff is faster than black + already installed for linting
        python = { "ruff_format", "ruff_organize_imports" },
        -- Java via google-java-format (added to Mason below)
        java = { "google-java-format" },
        -- Data / config (added round 5)
        yaml = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        toml = { "taplo" },
        sql = { "sqlfluff" },
        -- Docs
        markdown = { "prettier", "markdownlint-cli2" },
        -- Shell
        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
        -- Lua (config edits)
        lua = { "stylua" },
      },
    },
  },

  -- ── venv-selector: pick Python virtualenvs (.venv / venv / poetry / pixi) ──
  -- Plugin is installed via lang.python extra; we add the keymap + tighter opts.
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Use cached venv" },
    },
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          poetry = { command = "fd '/bin/python$' ~/.cache/pypoetry/virtualenvs --full-path --color never" },
          pixi   = { command = "fd '/bin/python$' .pixi/envs --full-path --color never" },
        },
      },
    },
  },

  -- ── Mason: install language servers, formatters, linters ─
  -- Pre-stage the toolchain so first open of each language doesn't have
  -- a "no LSP" gap. Mason auto-installs on Lazy sync.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Python (django/fastapi)
        "basedpyright",      -- type-aware LSP
        "ruff",              -- linter + formatter
        "debugpy",           -- DAP adapter
        "djlint",            -- Django template linter/formatter

        -- JS/TS (API frontends, scripting)
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettier",
        "prettierd",

        -- Java (spring boot)
        "jdtls",                    -- Java LSP
        "java-debug-adapter",
        "java-test",
        "vscode-spring-boot-tools",  -- application.yml/properties, bean nav, @-annotations
        "google-java-format",

        -- Go
        "gopls",
        "delve",                    -- DAP
        "gofumpt",
        "goimports",
        "golangci-lint",

        -- Docs (markdown + diagrams + prose linting)
        "markdownlint-cli2",
        "marksman",                 -- Markdown LSP
        "markdown-toc",
        "vale-ls",                  -- Prose style linter (Microsoft, etc.)

        -- Data / config formatters (round 5)
        "taplo",                    -- TOML formatter/LSP
        "sqlfluff",                 -- SQL formatter/linter
        "shfmt",                    -- shell formatter
        "stylua",                   -- Lua formatter
        "hadolint",                 -- Dockerfile linter
      })
    end,
  },
}
