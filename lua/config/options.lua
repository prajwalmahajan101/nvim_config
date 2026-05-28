-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true

-- Python: prefer basedpyright (modern fork with stricter type inference) over pyright;
-- ruff handles linting + formatting in one process.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Consistent rounded borders on all native floats (LSP hover, signature help,
-- diagnostics, :Lazy, :Mason). Native to Neovim 0.11+; only applies to floats
-- that don't set their own border, so plugin-specific borders still win.
vim.o.winborder = "rounded"

-- VSCode-familiar defaults ────────────────────────────────────────────────
-- System-clipboard yanks/pastes by default (Ctrl+C / Ctrl+V parity)
vim.opt.clipboard = "unnamedplus"
-- Confirm before exiting with unsaved changes (VSCode's "save before close" dialog)
vim.opt.confirm = true
-- Always show the signcolumn so the gutter doesn't jiggle when diagnostics appear
vim.opt.signcolumn = "yes"
-- Smaller scroll padding so the cursor doesn't bury at top/bottom (VSCode-like)
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- Keep undo history across sessions (VSCode's per-file undo persistence)
vim.opt.undofile = true
-- Live-preview substitutions as you type (`:%s/foo/bar/`)
vim.opt.inccommand = "split"
-- Word-wrap respects indent (better for markdown / docstrings)
vim.opt.breakindent = true
vim.opt.linebreak = true
